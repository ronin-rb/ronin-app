# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (c) 2023-2026 Hal Brodigan (postmodern.mod3@gmail.com)
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

require_relative '../types'

require 'nmap/command'

module Ronin
  module App
    module Types
      module Nmap
        # Represents a time value.
        Time = Types::String.constrained(format: ::Nmap::Command::Time::REGEXP)

        # Represents a hex string for the `--data` option (ex: `123ABC`).
        HexString = Types::String.constrained(format: ::Nmap::Command::HexString::REGEXP)

        # Represents a port number (ex: `80`).
        Port = Types::String.constrained(format: ::Nmap::Command::Port::REGEXP)

        # Represent a port-range (ex: `80` or `1-80`).
        PortRange = Types::String.constrained(format: ::Nmap::Command::PortRange::REGEXP)

        # Represent a comma separated list of port-ranges (ex: `1-80,443`).
        PortRangeList = Types::String.constrained(format: ::Nmap::Command::PortRangeList::REGEXP)

        # Represents a protocol list for the `-PO` option.
        ProtocolList = PortRangeList

        # Represents a single flag value for the `--scanflags` option.
        ScanFlag = Types::Symbol.enum(
          urg: 'urg',
          ack: 'ack',
          psh: 'psh',
          rst: 'rst',
          syn: 'syn',
          fin: 'fin'
        )

        # Represents `--scanflags` value.
        ScanFlags = Types::Array.of(ScanFlag)

        # Represents a value for the `--nsock-engine` option.
        NsockEngine = Types::String.enum(
          'iocp',
          'epoll',
          'kqueue',
          'poll',
          'select'
        )

        # Represents a value for the `--timing-template` option.
        TimingTemplate = Types::String.enum(
          'paranoid',
          'sneaky',
          'polite',
          'normal',
          'aggressive',
          'insane'
        )
      end
    end
  end
end
