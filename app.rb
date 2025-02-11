# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (c) 2023-2026 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-app is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-app is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with ronin-app.  If not, see <http://www.gnu.org/licenses/>.
#

$LOAD_PATH.unshift(File.join(__dir__,'lib'))

# classes
require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/flash'
require 'sinatra/reloader'

# configuration
require_relative 'config/database'
require_relative 'config/sidekiq'

# ronin libraries
require 'ronin/repos'
require 'ronin/payloads'
require 'ronin/exploits'
require 'ronin/support/encoding'

# param validations
require 'ronin/app/validations/install_repo_params'
require 'ronin/app/validations/import_params'
require 'ronin/app/validations/http_params'

# schema builders
require 'ronin/app/schemas/payloads/encoders/encode_schema'
require 'ronin/app/schemas/payloads/build_schema'

# helpers
require 'ronin/app/helpers/html'
require 'ronin/app/helpers/text'

# worker classes
require_relative 'workers/install_repo'
require_relative 'workers/update_repo'
require_relative 'workers/update_repos'
require_relative 'workers/remove_repo'
require_relative 'workers/purge_repos'
require_relative 'workers/import'

require 'ronin/app/version'
require 'sidekiq/api'

# others
require 'pagy'
require 'pagy/extras/bulma'

#
# Main app class.
#
class App < Sinatra::Base

  include Ronin::App
  include Pagy::Backend

  configure do
    enable :sessions
    enable :method_override
    register Sinatra::Flash
    helpers Sinatra::ContentFor
    helpers Helpers::HTML
    helpers Helpers::Text
  end

  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    include Pagy::Frontend
  end

  after do
    ActiveRecord::Base.connection_handler.clear_active_connections!
  end

  get '/' do
    erb :index
  end

  get '/repos' do
    @repos = Ronin::Repos.cache_dir

    erb :"repos/index"
  end

  get '/repos/install' do
    erb :"repos/install"
  end

  post '/repos/install' do
    result = Validations::InstallRepoParams.call(params)

    if result.success?
      Workers::InstallRepo.perform_async(result[:uri],result[:name])

      flash[:success] = "Installing repo at #{result[:uri]}"
      redirect '/repos'
    else
      @errors = result.errors

      flash[:danger] = 'Failed to install repo!'
      halt 400, erb(:"repos/install")
    end
  end

  post '/repos/update' do
    Workers::UpdateRepos.perform_async

    flash[:success] = 'All repos will be updated'
    redirect '/repos'
  end

  delete '/repos' do
    Workers::PurgeRepos.perform_async

    flash[:success] = 'All repos will be purged'
    redirect '/repos'
  end

  get '/repos/:name' do
    @repos = Ronin::Repos.cache_dir

    begin
      @repo = @repos[params[:name]]

      erb :"repos/show"
    rescue Ronin::Repos::RepositoryNotFound
      halt 404
    end
  end

  post '/repos/:name/update' do
    @repo = Ronin::Repos.cache_dir[params[:name]]

    Workers::UpdateRepo.perform_async(@repo.name)

    flash[:success] = "Repo #{@repo.name} enqueued for update"
    redirect "/repos/#{params[:name]}"
  rescue Ronin::Repos::RepositoryNotFound
    halt 404
  end

  delete '/repos/:name' do
    @repo = Ronin::Repos.cache_dir[params[:name]]

    Workers::RemoveRepo.perform_async(@repo.name)

    flash[:success] = "Repo #{@repo.name} enqueued for removal"
    redirect '/repos'
  rescue Ronin::Repos::RepositoryNotFound
    halt 404
  end

  get '/payloads' do
    @payloads = Ronin::Payloads.list_files

    erb :"payloads/index"
  end

  get '/payloads/encoders' do
    @payload_encoders = Ronin::Payloads::Encoders.list_files

    erb :"payloads/encoders/index"
  end

  get %r{/payloads/encoders/encode/(?<encoder_id>[a-z0-9_-]+(?:/[a-z0-9_-]+)*)} do
    @encoder_class = Ronin::Payloads::Encoders.load_class(params[:encoder_id])
    @encoder       = @encoder_class.new

    erb :"payloads/encoders/encode"
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  post %r{/payloads/encoders/encode/(?<encoder_id>[a-z0-9_-]+(?:/[a-z0-9_-]+)*)} do
    @encoder_class = Ronin::Payloads::Encoders.load_class(params[:encoder_id])
    @encoder       = @encoder_class.new

    form_schema = Schemas::Payloads::Encoders::EncodeSchema(@encoder_class)
    result      = form_schema.call(params)

    if result.success?
      encoder_params = result[:params].to_h
      encoder_params.compact!

      begin
        @encoder.params = encoder_params
      rescue Ronin::Core::Params::ParamError => error
        flash[:error] = "Failed to set params: #{error.message}"

        halt 400, erb(:"payloads/encoders/encode")
      end

      begin
        @encoder.validate
      rescue => error
        flash[:error] = "Failed to encode encoder: #{error.message}"

        halt 500, erb(:"payloads/encoders/encode")
      end

      @encoded_data = @encoder.encode(result[:data])

      erb :"payloads/encoders/encode"
    else
      @params = params
      @errors = result.errors

      halt 400, erb(:"payloads/encoders/encode")
    end
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  get %r{/payloads/encoders/(?<encoder_id>[a-z0-9_-]+(?:/[a-z0-9_-]+)*)} do
    @encoder = Ronin::Payloads::Encoders.load_class(params[:encoder_id])

    erb :"payloads/encoders/show"
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  get %r{/payloads/build/(?<payload_id>[a-z0-9_-]+(?:/[a-z0-9_-]+)*)} do
    @payload_class = Ronin::Payloads.load_class(params[:payload_id])
    @payload       = @payload_class.new

    erb :"payloads/build"
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  post %r{/payloads/build/(?<payload_id>[a-z0-9_-]+(?:/[a-z0-9_-]+)*)} do
    @payload_class = Ronin::Payloads.load_class(params[:payload_id])
    @payload       = @payload_class.new

    form_schema = Schemas::Payloads::BuildSchema(@payload_class)
    result      = form_schema.call(params)

    if result.success?
      payload_params = result[:params].to_h
      payload_params.compact!

      begin
        @payload.params = payload_params
      rescue Ronin::Core::Params::ParamError => error
        flash[:error] = "Failed to set params: #{error.message}"

        halt 400, erb(:"payloads/build")
      end

      begin
        @payload.perform_validate
        @payload.perform_build
      rescue => error
        flash[:error] = "Failed to build payload: #{error.message}"

        halt 500, erb(:"payloads/build")
      end

      @built_payload = @payload.to_s

      erb :"payloads/build"
    else
      @params = params
      @errors = result.errors

      halt 400, erb(:"payloads/build")
    end
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  get %r{/payloads/(?<payload_id>[a-z0-9_-]+(?:/[a-z0-9_-]+)*)} do
    @payload = Ronin::Payloads.load_class(params[:payload_id])

    erb :"payloads/show"
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  get '/exploits' do
    @exploits = Ronin::Exploits.list_files

    erb :"exploits/index"
  end

  get %r{/exploits/(?<exploit_id>[A-Za-z0-9_-]+(?:/[A-Za-z0-9_-]+)*)} do
    @exploit = Ronin::Exploits.load_class(params[:exploit_id])

    erb :"exploits/show"
  rescue Ronin::Core::ClassRegistry::ClassNotFound
    halt 404
  end

  get '/import' do
    erb :import
  end

  post '/import' do
    result = Validations::ImportParams.call(params)

    if result.success?
      @jid = Workers::Import.perform_async(result.to_h)

      type = result[:type]
      path = result[:path]

      flash[:success] = "Import of #{type} file #{path} enqueued"
      redirect '/import'
    else
      @errors = result.errors

      flash[:danger] = 'Failed to submit import job!'
      halt 400, erb(:import)
    end
  end

  get '/about' do
    @lockfile = Bundler::LockfileParser.new(File.read(Bundler.default_lockfile))

    erb :about
  end

  get '/queue' do
    @workers = Sidekiq::Workers.new.map do |_process_id, _thread_id, worker|
      payload = JSON.parse(worker["payload"])
      {
        queue:       worker["queue"],
        class:       payload["class"],
        args:        payload["args"],
        created_at:  Time.at(payload["created_at"]),
        enqueued_at: Time.at(payload["enqueued_at"]),
        run_at:      Time.at(worker["run_at"])
      }
    end

    erb :queue
  end

  get '/network/http' do
    erb :"network/http"
  end

  post '/network/http' do
    result = Validations::HTTPParams.call(params)

    if result.success?
      kwargs = result.to_h
      method = kwargs.delete(:method)
      url    = kwargs.delete(:url)

      @http_response = Ronin::Support::Network::HTTP.request(method,url,**kwargs)

      erb :"network/http"
    else
      @params = params
      @errors = result.errors
      halt 400, erb(:"network/http")
    end
  end

  private

  #
  # Returns the hash of variables used to initialize the Pagy object.
  #
  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page:  params["page"],
      items: vars[:items] || 25
    }
  end
end

require './app/db'
require './app/scanning'
