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

require 'sidekiq'
require 'dry-schema'

require 'ronin/vulns/url_scanner'
require 'ronin/vulns/importer'
require 'ronin/app/types/vulns'

module Workers
  #
  # Vulnerabilities scanner worker.
  #
  class Vulns

    include Ronin::App
    include Sidekiq::Worker
    sidekiq_options queue: :vulns, retry: false, backtrace: true

    Params = Dry::Schema::JSON() do
      required(:url).filled(:string)

      optional(:lfi).hash do
        optional(:os).maybe(Types::Vulns::LFI::OSType)
        optional(:depth).maybe(:integer)
        optional(:filter_bypass).maybe(Types::Vulns::LFI::FilterBypassType)
      end

      optional(:rfi).hash do
        optional(:filter_bypass).maybe(Types::Vulns::RFI::FilterBypassType)
        optional(:test_script_url).maybe(:string)
      end

      optional(:sqli).hash do
        optional(:escape_quote).maybe(:bool)
        optional(:escape_parens).maybe(:bool)
        optional(:terminate).maybe(:bool)
      end

      optional(:ssti).hash do
        optional(:escape).maybe(Types::Vulns::SSTI::EscapeType)
      end

      optional(:command_injection).hash do
        optional(:escape_quote).maybe(:string)
        optional(:escape_operator).maybe(:string)
        optional(:terminate).maybe(:string)
      end

      optional(:open_redirect).hash do
        optional(:test_url).maybe(:string)
      end

      before(:value_coercer) do |result|
        result.to_h.map do |_, value|
          value.is_a?(Hash) ? value.compact! : value
        end
      end
    end

    def perform(params)
      kwargs = validate(params)
      url    = kwargs.delete(:url)

      Ronin::Vulns::URLScanner.scan(url, **kwargs) do |vuln|
        Ronin::Vulns::Importer.import(vuln)
      end
    end

    #
    # Validates the given job params.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @return [Hash{Symbol => Object}]
    #   The validated and coerced params as a Symbol Hash.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    def validate(params)
      result = Params.call(params)

      if result.failure?
        raise(ArgumentError,"invalid nmap params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

  end
end
