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

require 'tempfile'
require 'masscan/command'
require 'ronin/masscan/importer'

module Workers
  #
  # `masscan` scanner worker.
  #
  class Masscan

    include Sidekiq::Worker
    sidekiq_options queue: :scan, retry: false, backtrace: true

    # The accepted JSON params which will be passed to {Masscan#perform}.
    Params = Dry::Schema::JSON() do
      required(:ips).array(:string)

      optional(:ports).value(:string)
      optional(:banners).value(:bool)
      optional(:rate).value(:integer)
      optional(:config_file).value(:string)
      optional(:adapter).value(:string)
      optional(:adapter_ip).value(:string)
      optional(:adapter_port).value(:string)
      optional(:adapter_mac).value(:string)
      optional(:adapter_vlan).value(:string)
      optional(:router_mac).value(:string)
      optional(:ping).value(:bool)
      optional(:exclude).value(:string)
      optional(:exclude_file).value(:string)
      optional(:include_file).value(:string)
      optional(:pcap_payloads).value(:string)
      optional(:nmap_payloads).value(:string)
      optional(:http_method).value(Types::HTTPMethod)
      optional(:http_url).value(:string)
      optional(:http_version).value(:string)
      optional(:http_host).value(:string)
      optional(:http_user_agent).value(:string)
      optional(:http_field).value(:string)
      optional(:http_cookie).value(:string)
      optional(:http_payload).value(:string)
      optional(:open_only).value(:bool)
      optional(:pcap).value(:string)
      optional(:packet_trace).value(:bool)
      optional(:pfring).value(:bool)
      optional(:shards).value(:string)
      optional(:seed).value(:integer)
      optional(:ttl).value(:integer)
      optional(:wait).value(:integer)
      optional(:retries).value(:integer)
    end

    #
    # Processes an `masscan` job.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    # @raise [RuntimeError]
    #   The `masscan` command failed or is not installed.
    #
    def perform(params)
      kwargs = validate(params)

      Tempfile.open(['masscan-', '.bin']) do |tempfile|
        status = ::Masscan::Command.run(
          **kwargs,
          interactive:   true,
          output_format: :binary,
          output_file:   tempfile.path
        )

        case status
        when true
          Ronin::Masscan::Importer.import_file(tempfile.path)
        when false
          raise("masscan command failed")
        when nil
          raise("masscan command not installed")
        end
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
        raise(ArgumentError,"invalid masscan params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

  end
end
