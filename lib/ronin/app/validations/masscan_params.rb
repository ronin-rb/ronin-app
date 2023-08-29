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

require 'dry/validation'
require 'ronin/app/types'

require 'masscan/command'

module Ronin
  module App
    module Validations
      #
      # Validations for the form params submitted to `POST /masscan`.
      #
      class MasscanParams < Dry::Validation::Contract

        params do
          required(:ips).filled(Types::Args).each(:filled?)

          optional(:ports).maybe(:string)
          optional(:banners).maybe(:bool)
          optional(:rate).maybe(:integer)
          optional(:config_file).maybe(:string)
          optional(:adapter).maybe(:string)
          optional(:adapter_ip).maybe(:string)
          optional(:adapter_port).maybe(:string)
          optional(:adapter_mac).maybe(:string)
          optional(:adapter_vlan).maybe(:string)
          optional(:router_mac).maybe(:string)
          optional(:ping).maybe(:bool)
          optional(:exclude).maybe(:string)
          optional(:exclude_file).maybe(:string)
          optional(:include_file).maybe(:string)
          optional(:pcap_payloads).maybe(:string)
          optional(:nmap_payloads).maybe(:string)
          optional(:http_method).maybe(Types::HTTPMethod)
          optional(:http_url).maybe(:string)
          optional(:http_version).maybe(:string)
          optional(:http_host).maybe(:string)
          optional(:http_user_agent).maybe(:string)
          optional(:http_field).maybe(:string)
          optional(:http_cookie).maybe(:string)
          optional(:http_payload).maybe(:string)
          optional(:open_only).maybe(:bool)
          optional(:pcap).maybe(:string)
          optional(:packet_trace).maybe(:bool)
          optional(:pfring).maybe(:bool)
          optional(:shards).maybe(:string)
          optional(:seed).maybe(:integer)
          optional(:ttl).maybe(:integer)
          optional(:wait).maybe(:integer)
          optional(:retries).maybe(:integer)

          before(:value_coercer) do |result|
            result.to_h.reject { |key,value| value.empty? }
          end
        end

        rule(:ports) do
          if value && value !~ ::Masscan::Command::PortList::REGEXP
            key.failure("invalid masscan port list")
          end
        end

        rule(:adapter_port) do
          if value && value !~ ::Masscan::Command::PortRange::REGEXP
            key.failure('invalid port or port range')
          end
        end

        rule(:router_mac) do
          if value && value !~ ::Masscan::Command::MACAddress::REGEXP
            key.failure('invalid MAC address')
          end
        end

        rule(:exclude) do
          if value && value !~ ::Masscan::Command::Target::REGEXP
            key.failure('invalid IP or IP range')
          end
        end

        rule(:shards) do
          if value && value !~ ::Masscan::Command::Shards::REGEXP
            key.failure('invalid shards value')
          end
        end

        #
        # Initializes and calls the validation contract.
        #
        # @param [Hash{String => Object}] params
        #   The HTTP params to validate.
        #
        # @return [Dry::Validation::Result]
        #   The validation result.
        #
        def self.call(params)
          new.call(params)
        end

      end
    end
  end
end
