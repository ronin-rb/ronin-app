require 'spec_helper'
require './app'

describe App, type: :feature do
  after do
    Ronin::DB::HostName.destroy_all
    Ronin::DB::ASN.destroy_all
    Ronin::DB::IPAddress.destroy_all
    Ronin::DB::MACAddress.destroy_all
    Ronin::DB::OpenPort.destroy_all
    Ronin::DB::Port.destroy_all
    Ronin::DB::Service.destroy_all
    Ronin::DB::WebVuln.destroy_all
    Ronin::DB::URL.destroy_all
    Ronin::DB::URLScheme.destroy_all
    Ronin::DB::Password.destroy_all
    Ronin::DB::Credential.destroy_all
    Ronin::DB::Advisory.destroy_all
    Ronin::DB::Software.destroy_all
    Ronin::DB::SoftwareVendor.destroy_all
    Ronin::DB::OS.destroy_all
    Ronin::DB::PhoneNumber.destroy_all
    Ronin::DB::StreetAddress.destroy_all
    Ronin::DB::Organization.destroy_all
    Ronin::DB::Person.destroy_all
  end

  context 'GET /db' do
    [
      '/db/host_names',
      '/db/asns',
      '/db/ip_addresses',
      '/db/mac_addresses',
      '/db/open_ports',
      '/db/ports',
      '/db/services',
      '/db/vulns',
      '/db/urls',
      '/db/url_schemes',
      '/db/passwords',
      '/db/credentials',
      '/db/advisories',
      '/db/software',
      '/db/software_vendors',
      '/db/oses',
      '/db/phone_numbers',
      '/db/street_addresses',
      '/db/organizations',
      '/db/people'
    ].each do |path|
      it "must contain a link to #{path}" do
        visit '/db'

        expect(page).to have_xpath("//a[@href='#{path}']")
      end
    end
  end

  context 'GET /db/host_names' do
    let!(:host_name) { Ronin::DB::HostName.find_or_import('example.com') }
    let(:xpath)      { "//a[text()='#{host_name}'][@href='/db/host_names/#{host_name.id}']" }

    it 'must return status 200 and include link to a host name in the body' do
      visit '/db/host_names'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/host_names/:id' do
    let!(:host_name)   { Ronin::DB::HostName.find_or_import('example.com') }
    let(:header_xpath) { "//h1[text()='Host Name: #{host_name}']" }

    it 'must return status 200 and include records data' do
      visit "/db/host_names/#{host_name.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/asns' do
    let!(:asn) { Ronin::DB::ASN.find_or_create_by(version: 4, range_start: '1.2.3.4', range_end: '1.2.3.4', number: 1234) }
    let(:xpath) { "//a[text()='#{asn}'][@href='/db/asns/#{asn.id}']" }

    it 'must return status 200 and include link to a asn in the body' do
      visit '/db/asns'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/asns/:id' do
    let!(:asn)         { Ronin::DB::ASN.find_or_create_by(version: 4, range_start: '1.2.3.4', range_end: '1.2.3.4', number: 1234) }
    let(:header_xpath) { "//h1[text()='ASN: #{asn}']" }

    it 'must return status 200 and include records data' do
      visit "/db/asns/#{asn.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/ip_addresses' do
    let!(:ip_address) { Ronin::DB::IPAddress.find_or_import('1.2.3.4') }
    let(:xpath)       { "//a[text()='#{ip_address}'][@href='/db/ip_addresses/#{ip_address.id}']" }

    it 'must return status 200 and include link to a ip address in the body' do
      visit '/db/ip_addresses'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/ip_addresses/:id' do
    let!(:ip_address)  { Ronin::DB::IPAddress.find_or_import('1.2.3.4') }
    let(:header_xpath) { "//h1[text()='IP Address: #{ip_address}']" }

    it 'must return status 200 and include records data' do
      visit "/db/ip_addresses/#{ip_address.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/mac_addresses' do
    let!(:mac_address) { Ronin::DB::MACAddress.find_or_import('01:23:45:67:89:ab') }
    let(:xpath)        { "//a[text()='#{mac_address}'][@href='/db/mac_addresses/#{mac_address.id}']" }

    it 'must return status 200 and include link to a mac address in the body' do
      visit '/db/mac_addresses'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/mac_addresses/:id' do
    let!(:mac_address) { Ronin::DB::MACAddress.find_or_import('01:23:45:67:89:ab') }
    let(:header_xpath) { "//h1[text()='MAC Address: #{mac_address}']" }

    it 'must return status 200 and include records data' do
      visit "/db/mac_addresses/#{mac_address.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/open_ports' do
    let!(:port)       { Ronin::DB::Port.find_or_create_by(number: 11) }
    let!(:ip_address) { Ronin::DB::IPAddress.find_or_import('1.2.3.4') }
    let!(:open_port)  { Ronin::DB::OpenPort.find_or_create_by(port: port, ip_address: ip_address) }
    let(:xpath)       { "//a[text()='#{open_port}'][@href='/db/open_ports/#{open_port.id}']" }

    it 'must return status 200 and include link to a mac address in the body' do
      visit '/db/open_ports'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/open_ports/:id' do
    let!(:port)        { Ronin::DB::Port.find_or_create_by(number: 11) }
    let!(:ip_address)  { Ronin::DB::IPAddress.find_or_import('1.2.3.4') }
    let!(:open_port)   { Ronin::DB::OpenPort.find_or_create_by(port: port, ip_address: ip_address) }
    let(:header_xpath) { "//h1[text()='Open Port: #{open_port}']" }

    it 'must return status 200 and include records data' do
      visit "/db/open_ports/#{open_port.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/ports' do
    let!(:port) { Ronin::DB::Port.find_or_create_by(number: 11) }
    let(:xpath) { "//a[text()='#{port}'][@href='/db/ports/#{port.id}']" }

    it 'must return status 200 and include link to a port in the body' do
      visit '/db/ports'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/ports/:id' do
    let!(:port)        { Ronin::DB::Port.find_or_create_by(number: 11) }
    let(:header_xpath) { "//h1[text()='Port: #{port}']" }

    it 'must return status 200 and include records data' do
      visit "/db/ports/#{port.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/services' do
    let!(:service) { Ronin::DB::Service.find_or_import('https') }
    let(:xpath)    { "//a[text()='#{service}'][@href='/db/services/#{service.id}']" }

    it 'must return status 200 and include link to a services in the body' do
      visit '/db/services'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/services/:id' do
    let!(:service)     { Ronin::DB::Service.find_or_import('https') }
    let(:header_xpath) { "//h1[text()='Service: #{service}']" }

    it 'must return status 200 and include records data' do
      visit "/db/services/#{service.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/vulns' do
    let!(:url)  { Ronin::DB::URL.find_or_import('http://example.com') }
    let!(:vuln) { Ronin::DB::WebVuln.find_or_create_by(url: url, type: 'reflected_xss', query_param: 'cat', request_method: :get) }
    let(:xpath) { "//a[text()='#{vuln.url}'][@href='/db/vulns/#{vuln.id}']" }

    it 'must return status 200 and include link to a vulns in the body' do
      visit '/db/vulns'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/vulns/:id' do
    let!(:url)         { Ronin::DB::URL.find_or_import('http://example.com') }
    let!(:vuln)        { Ronin::DB::WebVuln.find_or_create_by(url: url, type: 'reflected_xss', query_param: 'cat', request_method: :get) }
    let(:header_xpath) { "//h1[text()='Vulnerability: #{vuln.url}']" }

    it 'must return status 200 and include records data' do
      visit "/db/vulns/#{vuln.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/urls' do
    let!(:url)  { Ronin::DB::URL.find_or_import('http://example.com') }
    let(:xpath) { "//a[text()='#{url}'][@href='/db/urls/#{url.id}']" }

    it 'must return status 200 and include link to a url in the body' do
      visit '/db/urls'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/urls/:id' do
    let!(:url)         { Ronin::DB::URL.find_or_import('http://example.com') }
    let(:header_xpath) { "//h1[text()='URL: #{url}']" }

    it 'must return status 200 and include records data' do
      visit "/db/urls/#{url.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/url_schemes' do
    let!(:url_scheme) { Ronin::DB::URLScheme.find_or_create_by(name: 'https') }
    let(:xpath)       { "//a[text()='#{url_scheme}'][@href='/db/url_schemes/#{url_scheme.id}']" }

    it 'must return status 200 and include link to a url scheme in the body' do
      visit '/db/url_schemes'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/url_schemes/:id' do
    let!(:url_scheme)  { Ronin::DB::URLScheme.find_or_create_by(name: 'https') }
    let(:header_xpath) { "//h1[text()='URL Scheme: #{url_scheme}']" }

    it 'must return status 200 and include records data' do
      visit "/db/url_schemes/#{url_scheme.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/url_query_param_names' do
    let!(:url_query_param_name) { Ronin::DB::URLQueryParamName.find_or_create_by(name: 'cat') }
    let(:xpath)                 { "//a[text()='#{url_query_param_name}'][@href='/db/url_query_param_names/#{url_query_param_name.id}']" }

    it 'must return status 200 and include link to a url query param name in the body' do
      visit '/db/url_query_param_names'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/url_query_param_names/:id' do
    let!(:url_query_param_name) { Ronin::DB::URLQueryParamName.find_or_create_by(name: 'cat') }
    let(:header_xpath)          { "//h1[text()='URL Query Param Name: #{url_query_param_name}']" }

    it 'must return status 200 and include records data' do
      visit "/db/url_query_param_names/#{url_query_param_name.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/email_addresses' do
    let!(:email_address) { Ronin::DB::EmailAddress.find_or_import('foo@example.com') }
    let(:xpath)          { "//a[text()='#{email_address}'][@href='/db/email_addresses/#{email_address.id}']" }

    it 'must return status 200 and include link to an email address in the body' do
      visit '/db/email_addresses'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/email_addresses/:id' do
    let!(:email_address) { Ronin::DB::EmailAddress.find_or_import('foo@example.com') }
    let(:header_xpath)   { "//h1[text()='Email Address: #{email_address}']" }

    it 'must return status 200 and include records data' do
      visit "/db/email_addresses/#{email_address.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/user_names' do
    let!(:user_name) { Ronin::DB::UserName.find_or_import('user_name') }
    let(:xpath)      { "//a[text()='#{user_name}'][@href='/db/user_names/#{user_name.id}']" }

    it 'must return status 200 and include link to an user name in the body' do
      visit '/db/user_names'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/user_names/:id' do
    let!(:user_name)   { Ronin::DB::UserName.find_or_import('user_name') }
    let(:header_xpath) { "//h1[text()='User Name: #{user_name}']" }

    it 'must return status 200 and include records data' do
      visit "/db/user_names/#{user_name.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/passwords' do
    let!(:password) { Ronin::DB::Password.find_or_import('password') }
    let(:xpath)     { "//a[text()='#{password}'][@href='/db/passwords/#{password.id}']" }

    it 'must return status 200 and include link to a passwords in the body' do
      visit '/db/passwords'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/passwords/:id' do
    let!(:password)    { Ronin::DB::Password.find_or_import('password') }
    let(:header_xpath) { "//h1[text()='Password: #{password}']" }

    it 'must return status 200 and include records data' do
      visit "/db/passwords/#{password.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/credentials' do
    let!(:credential) { Ronin::DB::Credential.find_or_import('user:password') }
    let(:xpath)       { "//a[text()='#{credential}'][@href='/db/credentials/#{credential.id}']" }

    it 'must return status 200 and include link to a credential in the body' do
      visit '/db/credentials'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/credentials/:id' do
    let!(:credential)  { Ronin::DB::Credential.find_or_import('user:password') }
    let(:header_xpath) { "//h1[text()='Credential: #{credential}']" }

    it 'must return status 200 and include records data' do
      visit "/db/credentials/#{credential.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/advisories' do
    let!(:advisory) { Ronin::DB::Advisory.find_or_import('ABC-2023:12-34') }
    let(:xpath)     { "//a[text()='#{advisory}'][@href='/db/advisories/#{advisory}']" }

    it 'must return status 200 and include link to a advisory in the body' do
      visit '/db/advisories'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/advisories/:id' do
    let!(:advisory)    { Ronin::DB::Advisory.find_or_import('ABC-2023:12-34') }
    let(:header_xpath) { "//h1[text()='Advisory: #{advisory}']" }

    it 'must return status 200 and include records data' do
      visit "/db/advisories/#{advisory.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/software' do
    let!(:software) { Ronin::DB::Software.find_or_create_by(name: 'software', version: 1) }
    let(:xpath)     { "//a[text()='#{software}'][@href='/db/software/#{software.id}']" }

    it 'must return status 200 and include link to a software in the body' do
      visit '/db/software'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/software/:id' do
    let!(:software)    { Ronin::DB::Software.find_or_create_by(name: 'software', version: 1) }
    let(:header_xpath) { "//h1[text()='Software: #{software}']" }

    it 'must return status 200 and include records data' do
      visit "/db/software/#{software.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/software_vendors' do
    let!(:software_vendor) { Ronin::DB::SoftwareVendor.find_or_create_by(name: 'software vendor') }
    let(:xpath)            { "//a[text()='#{software_vendor}'][@href='/db/software_vendors/#{software_vendor.id}']" }

    it 'must return status 200 and include link to a software vendor in the body' do
      visit '/db/software_vendors'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/software_vendors/:id' do
    let!(:software_vendor) { Ronin::DB::SoftwareVendor.find_or_create_by(name: 'software vendor') }
    let(:header_xpath)     { "//h1[text()='Software Vendor: #{software_vendor}']" }

    it 'must return status 200 and include records data' do
      visit "/db/software_vendors/#{software_vendor.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/oses' do
    let!(:os)   { Ronin::DB::OS.find_or_create_by(name: 'os', version: 1) }
    let(:xpath) { "//a[text()='#{os}'][@href='/db/oses/#{os.id}']" }

    it 'must return status 200 and include link to a os in the body' do
      visit '/db/oses'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/oses/:id' do
    let!(:os)          { Ronin::DB::OS.find_or_create_by(name: 'os', version: 1) }
    let(:header_xpath) { "//h1[text()='OS: #{os}']" }

    it 'must return status 200 and include records data' do
      visit "/db/oses/#{os.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/phone_numbers' do
    let!(:phone_number) { Ronin::DB::PhoneNumber.find_or_import('+1 123-456-7890') }
    let(:xpath)         { "//a[text()='#{phone_number}'][@href='/db/phone_numbers/#{phone_number.id}']" }

    it 'must return status 200 and include link to a phone number in the body' do
      visit '/db/phone_numbers'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/phone_numbers/:id' do
    let!(:phone_number) { Ronin::DB::PhoneNumber.find_or_import('+1 123-456-7890') }
    let(:header_xpath)  { "//h1[text()='Phone Number: #{phone_number}']" }

    it 'must return status 200 and include records data' do
      visit "/db/phone_numbers/#{phone_number.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/street_addresses' do
    let!(:street_address) { Ronin::DB::StreetAddress.find_or_create_by(address: 'Address', city: 'City', state: 'State', zipcode: '00-000', country: 'Country') }
    let(:xpath)           { "//a[text()='#{street_address}'][@href='/db/street_addresses/#{street_address.id}']" }

    it 'must return status 200 and include link to a street address in the body' do
      visit '/db/street_addresses'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/street_addresses/:id' do
    let!(:street_address) { Ronin::DB::StreetAddress.find_or_create_by(address: 'Address', city: 'City', state: 'State', zipcode: '00-000', country: 'Country') }
    let(:header_xpath)    { "//h1[text()='Street Address: #{street_address}']" }

    it 'must return status 200 and include records data' do
      visit "/db/street_addresses/#{street_address.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/organizations' do
    let!(:organization) { Ronin::DB::Organization.find_or_import('org_name') }
    let(:xpath)         { "//a[text()='#{organization}'][@href='/db/organizations/#{organization.id}']" }

    it 'must return status 200 and include link to a organization in the body' do
      visit '/db/organizations'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/organizations/:id' do
    let!(:organization) { Ronin::DB::Organization.find_or_import('org_name') }
    let(:header_xpath)  { "//h1[text()='Organization: #{organization}']" }

    it 'must return status 200 and include records data' do
      visit "/db/organizations/#{organization.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end

  context 'GET /db/people' do
    let!(:person) { Ronin::DB::Person.find_or_import('full name') }
    let(:xpath)   { "//a[text()='#{person}'][@href='/db/people/#{person.id}']" }

    it 'must return status 200 and include link to a person in the body' do
      visit '/db/people'

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(xpath)
    end
  end

  context 'GET /db/people/:id' do
    let!(:person)      { Ronin::DB::Person.find_or_import('full name') }
    let(:header_xpath) { "//h1[text()='Person: #{person}']" }

    it 'must return status 200 and include records data' do
      visit "/db/people/#{person.id}"

      expect(page.status_code).to eq(200)
      expect(page).to have_xpath(header_xpath)
    end
  end
end
