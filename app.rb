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
require 'sinatra/content_for'
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
    helpers Sinatra::ContentFor
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
    @host_name_count            = Ronin::DB::HostName.count
    @asn_count                  = Ronin::DB::ASN.count
    @ip_address_count           = Ronin::DB::IPAddress.count
    @mac_address_count          = Ronin::DB::MACAddress.count
    @open_port_count            = Ronin::DB::OpenPort.count
    @port_count                 = Ronin::DB::Port.count
    @service_count              = Ronin::DB::Service.count
    @url_count                  = Ronin::DB::URL.count
    @url_scheme_count           = Ronin::DB::URLScheme.count
    @url_query_param_name_count = Ronin::DB::URLQueryParamName.count
    @email_address_count        = Ronin::DB::EmailAddress.count
    @user_name_count            = Ronin::DB::UserName.count
    @password_count             = Ronin::DB::Password.count
    @credential_count           = Ronin::DB::Credential.count
    @advisory_count             = Ronin::DB::Advisory.count
    @oses_count                 = Ronin::DB::OS.count

    erb :db
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

  get '/db/asns' do
    @asns = Ronin::DB::ASN.all

    erb :"db/asns"
  end

  get '/db/asns/:id' do
    @asn = Ronin::DB::ASN.find(params[:id])

    if @asn
      erb :"db/asn"
    else
      halt 404
    end
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

  get '/db/mac_addresses' do
    @mac_addresses = Ronin::DB::MACAddress.all

    erb :"db/mac_addresses"
  end

  get '/db/mac_addresses/:id' do
    @mac_address = Ronin::DB::MACAddress.find(params[:id])

    if @mac_address
      erb :"db/mac_address"
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

  get '/db/services/:id' do
    @service = Ronin::DB::Service.find(params[:id])

    if @service
      erb :"db/service"
    else
      halt 404
    end
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

  get '/db/url_schemes' do
    @url_schemes = Ronin::DB::URLScheme.all

    erb :"db/url_schemes"
  end

  get '/db/url_schemes/:id' do
    @url_scheme = Ronin::DB::URLScheme.find(params[:id])

    if @url_scheme
      erb :"db/url_scheme"
    else
      halt 404
    end
  end

  get '/db/url_query_param_names' do
    @url_query_param_names = Ronin::DB::URLQueryParamName.all

    erb :"db/url_query_param_names"
  end

  get '/db/url_query_param_names/:id' do
    @url_query_param_name = Ronin::DB::URLQueryParamName.find(params[:id])

    if @url_query_param_name
      erb :"db/url_query_param_name"
    else
      halt 404
    end
  end

  get '/db/email_addresses' do
    @email_addresses = Ronin::DB::EmailAddress.all

    erb :"db/email_addresses"
  end

  get '/db/email_addresses/:id' do
    @email_address = Ronin::DB::EmailAddress.find(params[:id])

    if @email_address
      erb :"db/email_address"
    else
      halt 404
    end
  end

  get '/db/user_names' do
    @user_names = Ronin::DB::UserName.all

    erb :"db/user_names"
  end

  get '/db/user_names/:id' do
    @user_name = Ronin::DB::UserName.find(params[:id])

    if @user_name
      erb :"db/user_name"
    else
      halt 404
    end
  end

  get '/db/passwords' do
    @passwords = Ronin::DB::Password.all

    erb :"db/passwords"
  end

  get '/db/passwords/:id' do
    @password = Ronin::DB::Password.find(params[:id])

    if @password
      erb :"db/password"
    else
      halt 404
    end
  end

  get '/db/credentials' do
    @credentials = Ronin::DB::Credential.all

    erb :"db/credentials"
  end

  get '/db/credentials/:id' do
    @credential = Ronin::DB::Credential.find(params[:id])

    if @credential
      erb :"db/credential"
    else
      halt 404
    end
  end

  get '/db/advisories' do
    @advisories = Ronin::DB::Advisory.all

    erb :"db/advisories"
  end

  get '/db/advisories/:id' do
    @advisory = Ronin::DB::Advisory.find(params[:id])

    if @advisory
      erb :"db/advisory"
    else
      halt 404
    end
  end

  get '/db/oses' do
    @oses = Ronin::DB::OS.all

    erb :"db/oses"
  end

  get '/db/oses/:id' do
    @os = Ronin::DB::OS.find(params[:id])

    if @os
      erb :"db/os"
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
