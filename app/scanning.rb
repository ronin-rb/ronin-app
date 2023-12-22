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

# param validations
require 'ronin/app/validations/recon_params'
require 'ronin/app/validations/nmap_params'
require 'ronin/app/validations/masscan_params'
require 'ronin/app/validations/spider_params'
require 'ronin/app/validations/vulns_params'

# helpers
require 'ronin/app/helpers/html'

# worker classes
require './workers/nmap'
require './workers/masscan'
require './workers/spider'
require './workers/recon'
require './workers/vulns'

#
# App class containing routes for scanning.
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

  get '/recon' do
    erb :recon
  end

  post '/recon' do
    result = Validations::ReconParams.call(params)

    if result.success?
      @jid = Workers::Recon.perform_async(result.to_h)

      scope = result[:scope]

      flash[:success] = "Recon of #{scope.join(', ')} enqueued"
      redirect '/recon'
    else
      @params = params
      @errors = result.errors

      flash[:danger] = 'Failed to submit recon request!'
      halt 400, erb(:recon)
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

  get '/vulns' do
    erb :vulns
  end

  post '/vulns' do
    result = Validations::VulnsParams.call(params)

    if result.success?
      @jid = Workers::Vulns.perform_async(result.to_h)

      url = result[:url]

      flash[:success] = "Vulnerabilities scanner of URL #{url} enqueued"
      redirect '/vulns'
    else
      @errors = result.errors

      flash[:danger] = 'Failed to submit vulnerabilities scan!'
      halt 400, erb(:vulns)
    end
  end
end
