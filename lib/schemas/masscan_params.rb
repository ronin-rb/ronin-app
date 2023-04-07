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

require 'dry/schema'

require 'types'

module Schemas
  MasscanParams = Dry::Schema.define do
    required(:ips).filled(Types::Args)

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
    optional(:retries).maybe(:bool)
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
  end
end
