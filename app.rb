# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (C) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
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
require 'sinatra/flash'
require 'sinatra/reloader'

# configuration
require './config/database'
require './config/sidekiq'

# worker classes
require 'workers/nmap'
require 'workers/masscan'
require 'workers/spider'

# param validations
require 'validations/nmap_params'
require 'validations/masscan_params'
require 'validations/spider_params'

# helpers
require 'helpers/html'

#
# Main app class.
#
class App < Sinatra::Base

  # ronin-app version
  VERSION = '0.1.0'

  configure do
    enable :sessions
    register Sinatra::Flash
    helpers Helpers::HTML
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  get '/about' do
    @lockfile = Bundler::LockfileParser.new(File.read(Bundler.default_lockfile))

    erb :about
  end

  get '/db' do
    @ip_address_count = Ronin::DB::IPAddress.count
    @host_name_count  = Ronin::DB::HostName.count
    @open_port_count  = Ronin::DB::OpenPort.count
    @port_count       = Ronin::DB::Port.count
    @service_count    = Ronin::DB::Service.count
    @url_count        = Ronin::DB::URL.count

    erb :db
  end

  get '/db/ip_addresses' do
    @ip_addresses = Ronin::DB::IPAddress.all

    erb :"db/ip_addresses"
  end

  get '/db/ip_addresses/:id' do
    @ip_address = Ronin::DB::IPAddress.find(params[:id])

    if @ip_address
      erb :"db/ip_address"
    else
      halt 404
    end
  end

  get '/db/host_names' do
    @host_names = Ronin::DB::HostName.all

    erb :"db/host_names"
  end

  get '/db/host_names/:id' do
    @host_name = Ronin::DB::HostName.find(params[:id])

    if @host_name
      erb :"db/host_name"
    else
      halt 404
    end
  end

  get '/db/open_ports' do
    @open_ports = Ronin::DB::OpenPort.all

    erb :"db/open_ports"
  end

  get '/db/open_ports/:id' do
    @open_port = Ronin::DB::OpenPort.find(params[:id])

    if @open_port
      erb :"db/open_port"
    else
      halt 404
    end
  end

  get '/db/ports' do
    @ports = Ronin::DB::Port.all

    erb :"db/ports"
  end

  get '/db/ports/:id' do
    @port = Ronin::DB::Port.find(params[:id])

    if @port
      erb :"db/port"
    else
      halt 404
    end
  end

  get '/db/services' do
    @services = Ronin::DB::Service.all

    erb :"db/services"
  end

  get '/db/urls' do
    @urls = Ronin::DB::URL.all

    erb :"db/urls"
  end

  get '/db/urls/:id' do
    @url = Ronin::DB::URL.find(params[:id])

    if @url
      erb :"db/url"
    else
      halt 404
    end
  end

  get '/nmap' do
    erb :nmap
  end

  post '/nmap' do
    result = Validations::NmapParams.call(params)

    if result.success?
      @jid = Workers::Nmap.perform_async(result.to_h)

      targets = result[:targets]

      flash[:success] = "Scan of #{targets.join(',')} enqueued"
      redirect '/nmap'
    else
      @params = params
      @errors = result.errors

      flash[:danger] = 'Failed to submit nmap scan!'
      halt 400, erb(:nmap)
    end
  end

  get '/masscan' do
    erb :masscan
  end

  post '/masscan' do
    result = Validations::MasscanParams.call(params)

    if result.success?
      @jid = Workers::Masscan.perform_async(result.to_h)

      targets = result[:ips]

      flash[:success] = "Scan of #{targets.join(',')} enqueued"
      redirect '/masscan'
    else
      @errors = result.errors

      flash[:danger] = 'Failed to submit masscan scan!'
      halt 400, erb(:masscan)
    end
  end

  get '/spider' do
    erb :spider
  end

  post '/spider' do
    result = Validations::SpiderParams.call(params)

    if result.success?
      @jid = Workers::Spider.perform_async(result.to_h)

      type   = result[:type]
      target = result[:target]

      flash[:success] = "Web spider of #{type} #{target} enqueued"
      redirect '/spider'
    else
      @errors = result.errors

      flash[:danger] = 'Failed to submit spider scan!'
      halt 400, erb(:spider)
    end
  end

end
