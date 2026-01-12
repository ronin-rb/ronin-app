# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
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
require 'ronin/app/types/nmap'

require 'tempfile'
require 'nmap/command'
require 'ronin/nmap/importer'

module Workers
  #
  # `nmap` scanner worker.
  #
  class Nmap

    include Ronin::App
    include Sidekiq::Worker

    sidekiq_options queue: :scan, retry: false, backtrace: true

    # The accepted JSON params which will be passed to {Nmap#perform}.
    Params = Dry::Schema::JSON() do
      required(:targets).array(:string).each(:string)

      # TARGET SPECIFICATIONS:
      optional(:target_file).maybe(:string)
      optional(:random_targets).maybe(:integer)
      optional(:exclude).maybe(:array)
      optional(:exclude_file).maybe(:string)

      # HOST DISCOVERY:
      optional(:ping).maybe(:bool)
      optional(:skip_discovery).maybe(:bool)
      optional(:syn_discovery).maybe(Types::Bool | Types::Nmap::PortRangeList)
      optional(:ack_discovery).maybe(Types::Bool | Types::Nmap::PortRangeList)
      optional(:udp_discovery).maybe(Types::Bool | Types::Nmap::PortRangeList)
      optional(:sctp_init_ping).maybe(Types::Bool | Types::Nmap::PortRangeList)
      optional(:icmp_echo_discovery).maybe(:bool)
      optional(:icmp_timestamp_discovery).maybe(:bool)
      optional(:icmp_netmask_discovery).maybe(:bool)
      optional(:ip_ping).maybe(Types::Bool | Types::Nmap::ProtocolList)
      optional(:arp_ping).maybe(:bool)
      optional(:traceroute).maybe(:bool)
      optional(:disable_dns).maybe(:bool)
      optional(:enable_dns).maybe(:bool)
      optional(:resolve_all).maybe(:bool)
      optional(:unique).maybe(:bool)
      optional(:dns_servers).maybe(:array)
      optional(:system_dns).maybe(:bool)

      # PORT SCANNING TECHNIQUES:
      optional(:syn_scan).maybe(:bool)
      optional(:connect_scan).maybe(:bool)
      optional(:udp_scan).maybe(:bool)
      optional(:sctp_init_scan).maybe(:bool)
      optional(:null_scan).maybe(:bool)
      optional(:fin_scan).maybe(:bool)
      optional(:xmas_scan).maybe(:bool)
      optional(:ack_scan).maybe(:bool)
      optional(:window_scan).maybe(:bool)
      optional(:maimon_scan).maybe(:bool)
      optional(:scan_flags).maybe(Types::Nmap::ScanFlags)
      optional(:sctp_cookie_echo_scan).maybe(:bool)
      optional(:idle_scan).maybe(:string)
      optional(:ip_scan).maybe(:bool)
      optional(:ftp_bounce_scan).maybe(:string)

      # PORT SPECIFICATION AND SCAN ORDER:
      optional(:ports).maybe(Types::Nmap::PortRangeList)
      optional(:exclude_ports).maybe(Types::Nmap::PortRangeList)
      optional(:fast).maybe(:bool)
      optional(:consecutively).maybe(:bool)
      optional(:top_ports).maybe(:integer)
      optional(:port_ratio).maybe(:float)

      # SERVICE/VERSION DETECTION:
      optional(:service_scan).maybe(:bool)
      optional(:all_ports).maybe(:bool)
      optional(:version_intensity).maybe(:integer)
      optional(:version_light).maybe(:bool)
      optional(:version_all).maybe(:bool)
      optional(:version_trace).maybe(:bool)

      # OS DETECTION:
      optional(:os_fingerprint).maybe(:bool)
      optional(:limit_os_scan).maybe(:bool)
      optional(:max_os_scan).maybe(:bool)
      optional(:max_os_tries).maybe(:bool)

      # TIMING AND PERFORMANCE:
      optional(:min_host_group).maybe(:integer)
      optional(:max_host_group).maybe(:integer)
      optional(:min_parallelism).maybe(:integer)
      optional(:max_parallelism).maybe(:integer)
      optional(:min_rtt_timeout).maybe(Types::Nmap::Time)
      optional(:max_rtt_timeout).maybe(Types::Nmap::Time)
      optional(:initial_rtt_timeout).maybe(Types::Nmap::Time)
      optional(:max_retries).maybe(:integer)
      optional(:host_timeout).maybe(Types::Nmap::Time)
      optional(:script_timeout).maybe(Types::Nmap::Time)
      optional(:scan_delay).maybe(Types::Nmap::Time)
      optional(:max_scan_delay).maybe(Types::Nmap::Time)
      optional(:min_rate).maybe(:integer)
      optional(:max_rate).maybe(:integer)
      optional(:defeat_rst_ratelimit).maybe(:bool)
      optional(:defeat_icmp_ratelimit).maybe(:bool)
      optional(:nsock_engine).maybe(Types::Nmap::NsockEngine)
      optional(:timing_template).maybe(Types::Nmap::TimingTemplate)

      # FIREWALL/IDS EVASION AND SPOOFING:
      optional(:packet_fragments).maybe(:bool)
      optional(:mtu).maybe(Types::Bool | Types::Integer)
      optional(:decoys).maybe(:array)
      optional(:spoof).maybe(:string)
      optional(:interface).maybe(:string)
      optional(:source_port).maybe(Types::Nmap::Port)
      optional(:proxies).maybe(:array)
      optional(:data).maybe(Types::Nmap::HexString)
      optional(:data_string).maybe(:string)
      optional(:data_length).maybe(:integer)
      optional(:ip_options).maybe(:string)
      optional(:ttl).maybe(:integer)
      optional(:randomize_hosts).maybe(:bool)
      optional(:spoof_mac).maybe(:string)
      optional(:bad_checksum).maybe(:bool)
      optional(:sctp_adler32).maybe(:bool)

      # MISC:
      optional(:ipv6).maybe(:bool)
      optional(:all).maybe(:bool)
      optional(:nmap_datadir).maybe(:string)
      optional(:servicedb).maybe(:string)
      optional(:versiondb).maybe(:string)
      optional(:send_eth).maybe(:bool)
      optional(:send_ip).maybe(:bool)
      optional(:privileged).maybe(:bool)
      optional(:unprivileged).maybe(:bool)
      optional(:release_memory).maybe(:bool)
    end

    #
    # Processes an `nmap` job.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    # @raise [RuntimeError]
    #   The `nmap` command failed or is not installed.
    #
    def perform(params)
      kwargs = validate(params)

      Tempfile.open(['nmap-', '.xml']) do |tempfile|
        status = ::Nmap::Command.run(
          **kwargs,
          verbose:    true,
          privileged: true,
          output_xml: tempfile.path
        )

        case status
        when true
          Ronin::Nmap::Importer.import_file(tempfile.path)
        when false
          raise("nmap command failed")
        when nil
          raise("nmap command not installed")
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
        raise(ArgumentError,"invalid nmap params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

  end
end
