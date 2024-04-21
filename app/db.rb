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

#
# App class containing routes for database.
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
    @software_count             = Ronin::DB::Software.count
    @software_vendor_count      = Ronin::DB::SoftwareVendor.count
    @oses_count                 = Ronin::DB::OS.count
    @vulns_count                = Ronin::DB::WebVuln.count
    @phone_number_count         = Ronin::DB::PhoneNumber.count
    @street_address_count       = Ronin::DB::StreetAddress.count
    @organization_count         = Ronin::DB::Organization.count
    @people_count               = Ronin::DB::Person.count

    erb :db
  end

  get '/db/host_names' do
    @pagy, @host_names = pagy(Ronin::DB::HostName)

    erb :"db/host_names/index"
  end

  get '/db/host_names/:id' do
    @host_name = Ronin::DB::HostName.find(params[:id])

    if @host_name
      erb :"db/host_names/show"
    else
      halt 404
    end
  end

  {
    mac_addresses:   Ronin::DB::MACAddress,
    ip_addresses:    Ronin::DB::IPAddress,
    host_names:      Ronin::DB::HostName,
    ports:           Ronin::DB::Port,
    services:        Ronin::DB::Service,
    open_ports:      Ronin::DB::OpenPort,
    credentials:     Ronin::DB::Credential,
    urls:            Ronin::DB::URL,
    user_names:      Ronin::DB::UserName,
    email_addresses: Ronin::DB::EmailAddress,
    passwords:       Ronin::DB::Password,
    advisories:      Ronin::DB::Advisory
  }.each do |name, model|
    post "/db/#{name}/:id/notes" do
      @record = model.find(params[:id])

      if @record
        if @record.notes.create!(body: params[:body])
          flash[:success] = "Note added successfully."
        else
          flash[:danger] = "Failed to create Note."
        end

        redirect "/db/#{name}/#{params[:id]}"
      else
        halt 404
      end
    end

    delete "/db/#{name}/:id/notes/:note_id" do
      @record = model.find(params[:id])

      if @record
        @record.notes.destroy(params[:note_id])
      else
        halt 404
      end
    end
  end

  put "/db/notes/:id" do
    @record = Ronin::DB::Note.find_by(params[:id])

    unless @record || @record.update(params)
      halt 404
    end
  end

  get '/db/asns' do
    @pagy, @asns = pagy(Ronin::DB::ASN)

    erb :"db/asns/index"
  end

  get '/db/asns/:id' do
    @asn = Ronin::DB::ASN.find(params[:id])

    if @asn
      erb :"db/asns/show"
    else
      halt 404
    end
  end

  get '/db/ip_addresses' do
    @pagy, @ip_addresses = pagy(Ronin::DB::IPAddress)

    erb :"db/ip_addresses/index"
  end

  get '/db/ip_addresses/:id' do
    @ip_address = Ronin::DB::IPAddress.find(params[:id])

    if @ip_address
      erb :"db/ip_addresses/show"
    else
      halt 404
    end
  end

  get '/db/mac_addresses' do
    @pagy, @mac_addresses = pagy(Ronin::DB::MACAddress)

    erb :"db/mac_addresses/index"
  end

  get '/db/mac_addresses/:id' do
    @mac_address = Ronin::DB::MACAddress.find(params[:id])

    if @mac_address
      erb :"db/mac_addresses/show"
    else
      halt 404
    end
  end

  get '/db/open_ports' do
    @pagy, @open_ports = pagy(Ronin::DB::OpenPort)

    erb :"db/open_ports/index"
  end

  get '/db/open_ports/:id' do
    @open_port = Ronin::DB::OpenPort.find(params[:id])

    if @open_port
      erb :"db/open_ports/show"
    else
      halt 404
    end
  end

  get '/db/ports' do
    @pagy, @ports = pagy(Ronin::DB::Port)

    erb :"db/ports/index"
  end

  get '/db/ports/:id' do
    @port = Ronin::DB::Port.find(params[:id])

    if @port
      erb :"db/ports/show"
    else
      halt 404
    end
  end

  get '/db/services' do
    @pagy, @services = pagy(Ronin::DB::Service)

    erb :"db/services/index"
  end

  get '/db/services/:id' do
    @service = Ronin::DB::Service.find(params[:id])

    if @service
      erb :"db/services/show"
    else
      halt 404
    end
  end

  get '/db/urls' do
    @pagy, @urls = pagy(Ronin::DB::URL)

    erb :"db/urls/index"
  end

  get '/db/urls/:id' do
    @url = Ronin::DB::URL.find(params[:id])

    if @url
      erb :"db/urls/show"
    else
      halt 404
    end
  end

  get '/db/url_schemes' do
    @pagy, @url_schemes = pagy(Ronin::DB::URLScheme)

    erb :"db/url_schemes/index"
  end

  get '/db/url_schemes/:id' do
    @url_scheme = Ronin::DB::URLScheme.find(params[:id])

    if @url_scheme
      erb :"db/url_schemes/show"
    else
      halt 404
    end
  end

  get '/db/url_query_param_names' do
    @pagy, @url_query_param_names = pagy(Ronin::DB::URLQueryParamName)

    erb :"db/url_query_param_names/index"
  end

  get '/db/url_query_param_names/:id' do
    @url_query_param_name = Ronin::DB::URLQueryParamName.find(params[:id])

    if @url_query_param_name
      erb :"db/url_query_param_names/show"
    else
      halt 404
    end
  end

  get '/db/email_addresses' do
    @pagy, @email_addresses = pagy(Ronin::DB::EmailAddress)

    erb :"db/email_addresses/index"
  end

  get '/db/email_addresses/:id' do
    @email_address = Ronin::DB::EmailAddress.find(params[:id])

    if @email_address
      erb :"db/email_addresses/show"
    else
      halt 404
    end
  end

  get '/db/user_names' do
    @pagy, @user_names = pagy(Ronin::DB::UserName)

    erb :"db/user_names/index"
  end

  get '/db/user_names/:id' do
    @user_name = Ronin::DB::UserName.find(params[:id])

    if @user_name
      erb :"db/user_names/show"
    else
      halt 404
    end
  end

  get '/db/passwords' do
    @pagy, @passwords = pagy(Ronin::DB::Password)

    erb :"db/passwords/index"
  end

  get '/db/passwords/:id' do
    @password = Ronin::DB::Password.find(params[:id])

    if @password
      erb :"db/passwords/show"
    else
      halt 404
    end
  end

  get '/db/credentials' do
    @pagy, @credentials = pagy(Ronin::DB::Credential)

    erb :"db/credentials/index"
  end

  get '/db/credentials/:id' do
    @credential = Ronin::DB::Credential.find(params[:id])

    if @credential
      erb :"db/credentials/show"
    else
      halt 404
    end
  end

  get '/db/advisories' do
    @pagy, @advisories = pagy(Ronin::DB::Advisory)

    erb :"db/advisories/index"
  end

  get '/db/advisories/:id' do
    @advisory = Ronin::DB::Advisory.find(params[:id])

    if @advisory
      erb :"db/advisories/show"
    else
      halt 404
    end
  end

  get '/db/software' do
    @pagy, @software = pagy(Ronin::DB::Software)

    erb :"db/software/index"
  end

  get '/db/software/:id' do
    @software = Ronin::DB::Software.find(params[:id])

    if @software
      erb :"db/software/show"
    else
      halt 404
    end
  end

  get '/db/software_vendors' do
    @pagy, @software_vendors = pagy(Ronin::DB::SoftwareVendor)

    erb :"db/software_vendors/index"
  end

  get '/db/software_vendors/:id' do
    @software_vendor = Ronin::DB::SoftwareVendor.find(params[:id])

    erb :"db/software_vendors/show"
  end

  get '/db/oses' do
    @pagy, @oses = pagy(Ronin::DB::OS)

    erb :"db/oses/index"
  end

  get '/db/oses/:id' do
    @os = Ronin::DB::OS.find(params[:id])

    if @os
      erb :"db/oses/show"
    else
      halt 404
    end
  end

  get '/db/vulns' do
    @pagy, @vulns = pagy(Ronin::DB::WebVuln)

    erb :"db/vulns/index"
  end

  get '/db/vulns/:id' do
    @vuln = Ronin::DB::WebVuln.find(params[:id])

    if @vuln
      erb :"db/vulns/show"
    else
      halt 404
    end
  end

  get '/db/phone_numbers' do
    @pagy, @phone_numbers = pagy(Ronin::DB::PhoneNumber)

    erb :"db/phone_numbers/index"
  end

  get '/db/phone_numbers/:id' do
    @phone_number = Ronin::DB::PhoneNumber.find(params[:id])

    if @phone_number
      erb :"db/phone_numbers/show"
    else
      halt 404
    end
  end

  get '/db/street_addresses' do
    @pagy, @street_addresses = pagy(Ronin::DB::StreetAddress)

    erb :"db/street_addresses/index"
  end

  get '/db/street_addresses/:id' do
    @phone_number = Ronin::DB::StreetAddress.find(params[:id])

    if @phone_number
      erb :"db/street_addresses/show"
    else
      halt 404
    end
  end

  get '/db/organizations' do
    @pagy, @organizations = pagy(Ronin::DB::Organization)

    erb :"db/organizations/index"
  end

  get '/db/organizations/:id' do
    @organization = Ronin::DB::Organization.find(params[:id])

    if @organization
      erb :"db/organizations/show"
    else
      halt 404
    end
  end

  get '/db/organization_departments/:id' do
    @organization_department = Ronin::DB::OrganizationDepartment.find(params[:id])

    if @organization_department
      erb :"db/organizations/departments/show"
    else
      halt 404
    end
  end

  get '/db/organization_members/:id' do
    @organization_member = Ronin::DB::OrganizationMember.find(params[:id])

    if @organization_member
      erb :"db/organizations/members/show"
    else
      halt 404
    end
  end

  get '/db/people' do
    @pagy, @people = pagy(Ronin::DB::Person)

    erb :"db/people/index"
  end

  get '/db/people/:id' do
    @person = Ronin::DB::Person.find(params[:id])

    if @person
      erb :"db/people/show"
    else
      halt 404
    end
  end

  {
    host_names:            Ronin::DB::HostName,
    asns:                  Ronin::DB::ASN,
    ip_addresses:          Ronin::DB::IPAddress,
    mac_addresses:         Ronin::DB::MACAddress,
    open_ports:            Ronin::DB::OpenPort,
    ports:                 Ronin::DB::Port,
    services:              Ronin::DB::Service,
    urls:                  Ronin::DB::URL,
    url_schemes:           Ronin::DB::URLScheme,
    url_query_param_names: Ronin::DB::URLQueryParamName,
    email_addresses:       Ronin::DB::EmailAddress,
    user_names:            Ronin::DB::UserName,
    passwords:             Ronin::DB::Password,
    credentials:           Ronin::DB::Credential,
    advisories:            Ronin::DB::Advisory,
    software:              Ronin::DB::Software,
    software_vendors:      Ronin::DB::SoftwareVendor,
    oses:                  Ronin::DB::OS,
    vulns:                 Ronin::DB::WebVuln,
    phone_numbers:         Ronin::DB::PhoneNumber,
    street_addresses:      Ronin::DB::StreetAddress,
    organizations:         Ronin::DB::Organization,
    people:                Ronin::DB::Person
  }.each do |name, model|
    delete "/db/#{name}" do
      if model.destroy_all
        flash[:success] = "Records deleted successfully."
      else
        flash[:danger] = "Failed to delete records."
      end

      redirect "/db/#{name}"
    end

    delete "/db/#{name}/:id" do
      @record = model.find(params[:id])

      if @record
        if @record.destroy
          flash[:success] = "Record deleted successfully."

          redirect "/db/#{name}"
        else
          flash[:danger] = "Failed to delete record."
        end
      else
        halt 404
      end
    end
  end
end
