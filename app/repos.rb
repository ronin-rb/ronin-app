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

# ronin libraries
require 'ronin/repos'

# param validations
require 'ronin/app/validations/install_repo_params'

# worker classes
require_relative '../workers/install_repo'
require_relative '../workers/update_repo'
require_relative '../workers/update_repos'
require_relative '../workers/remove_repo'
require_relative '../workers/purge_repos'

#
# App class containing routes for repos.
#
class App < Sinatra::Base

  include Ronin::App
  include Pagy::Backend

  configure do
    enable :sessions
    register Sinatra::Flash
    helpers Sinatra::ContentFor
    helpers Helpers::HTML
  end

  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    include Pagy::Frontend
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
end
