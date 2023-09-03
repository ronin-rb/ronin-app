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
      required(:targets).array(:string)

      # TARGET SPECIFICATIONS:
      optional(:target_file).value(:string)
      optional(:random_targets).value(:integer)
      optional(:exclude).value(Types::List)
      optional(:exclude_file).value(:string)

      # HOST DISCOVERY:
      optional(:list).value(:bool)
      optional(:ping).value(:bool)
      optional(:skip_discovery).value(:bool)
      optional(:syn_discovery).value(Types::Bool | Types::Nmap::PortRangeList)
      optional(:ack_discovery).value(Types::Bool | Types::Nmap::PortRangeList)
      optional(:udp_discovery).value(Types::Bool | Types::Nmap::PortRangeList)
      optional(:sctp_init_ping).value(Types::Bool | Types::Nmap::PortRangeList)
      optional(:icmp_echo_discovery).value(:bool)
      optional(:icmp_timestamp_discovery).value(:bool)
      optional(:icmp_netmask_discovery).value(:bool)
      optional(:ip_ping).value(Types::Bool | Types::Nmap::ProtocolList)
      optional(:arp_ping).value(:bool)
      optional(:traceroute).value(:bool)
      optional(:disable_dns).value(:bool)
      optional(:enable_dns).value(:bool)
      optional(:resolve_all).value(:bool)
      optional(:unique).value(:bool)
      optional(:dns_servers).value(Types::List)
      optional(:system_dns).value(:bool)

      # PORT SCANNING TECHNIQUES:
      optional(:syn_scan).value(:bool)
      optional(:connect_scan).value(:bool)
      optional(:udp_scan).value(:bool)
      optional(:sctp_init_scan).value(:bool)
      optional(:null_scan).value(:bool)
      optional(:fin_scan).value(:bool)
      optional(:xmas_scan).value(:bool)
      optional(:ack_scan).value(:bool)
      optional(:window_scan).value(:bool)
      optional(:maimon_scan).value(:bool)
      optional(:scan_flags).value(Types::Nmap::ScanFlags)
      optional(:sctp_cookie_echo_scan).value(:bool)
      optional(:idle_scan).value(:string)
      optional(:ip_scan).value(:bool)
      optional(:ftp_bounce_scan).value(:string)

      # PORT SPECIFICATION AND SCAN ORDER:
      optional(:ports).value(Types::Nmap::PortRangeList)
      optional(:exclude_ports).value(Types::Nmap::PortRangeList)
      optional(:fast).value(:bool)
      optional(:consecutively).value(:bool)
      optional(:top_ports).value(:integer)
      optional(:port_ratio).value(:float)

      # SERVICE/VERSION DETECTION:
      optional(:service_scan).value(:bool)
      optional(:all_ports).value(:bool)
      optional(:version_intensity).value(:integer)
      optional(:version_light).value(:bool)
      optional(:version_all).value(:bool)
      optional(:version_trace).value(:bool)
      optional(:rpc_scan).value(:bool)

      # OS DETECTION:
      optional(:os_fingerprint).value(:bool)
      optional(:limit_os_scan).value(:bool)
      optional(:max_os_scan).value(:bool)
      optional(:max_os_tries).value(:bool)

      # TIMING AND PERFORMANCE:
      optional(:min_host_group).value(:integer)
      optional(:max_host_group).value(:integer)
      optional(:min_parallelism).value(:integer)
      optional(:max_parallelism).value(:integer)
      optional(:min_rtt_timeout).value(Types::Nmap::Time)
      optional(:max_rtt_timeout).value(Types::Nmap::Time)
      optional(:initial_rtt_timeout).value(Types::Nmap::Time)
      optional(:max_retries).value(:integer)
      optional(:host_timeout).value(Types::Nmap::Time)
      optional(:script_timeout).value(Types::Nmap::Time)
      optional(:scan_delay).value(Types::Nmap::Time)
      optional(:max_scan_delay).value(Types::Nmap::Time)
      optional(:min_rate).value(:integer)
      optional(:max_rate).value(:integer)
      optional(:defeat_rst_ratelimit).value(:bool)
      optional(:defeat_icmp_ratelimit).value(:bool)
      optional(:nsock_engine).value(Types::Nmap::NsockEngine)
      optional(:timing_template).value(Types::Nmap::TimingTemplate)

      # FIREWALL/IDS EVASION AND SPOOFING:
      optional(:packet_fragments).value(:bool)
      optional(:mtu).value(:bool)
      optional(:decoys).value(Types::List)
      optional(:spoof).value(:string)
      optional(:interface).value(:string)
      optional(:source_port).value(Types::Nmap::Port)
      optional(:proxies).value(Types::List)
      optional(:data).value(Types::Nmap::HexString)
      optional(:data_string).value(:string)
      optional(:data_length).value(:integer)
      optional(:ip_options).value(:string)
      optional(:ttl).maybe(:integer)
      optional(:randomize_hosts).value(:bool)
      optional(:spoof_mac).value(:string)
      optional(:bad_checksum).value(:bool)
      optional(:sctp_adler32).value(:bool)

      # MISC:
      optional(:ipv6).value(:bool)
      optional(:all).value(:bool)
      optional(:nmap_datadir).value(:string)
      optional(:servicedb).value(:string)
      optional(:versiondb).value(:string)
      optional(:send_eth).value(:bool)
      optional(:send_ip).value(:bool)
      optional(:privileged).value(:bool)
      optional(:unprivileged).value(:bool)
      optional(:release_memory).value(:bool)
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
