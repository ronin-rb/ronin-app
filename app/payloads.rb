# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (C) 2023-2024 Hal Brodigan (postmodern.mod3@gmail.com)
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
require 'ronin/payloads'

# schema builders
require 'ronin/app/schemas/payloads/encoders/encode_schema'
require 'ronin/app/schemas/payloads/build_schema'

#
# App class containing routes for payloads.
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
end
