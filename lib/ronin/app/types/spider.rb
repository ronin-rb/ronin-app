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

require 'ronin/app/types'

module Ronin
  module App
    module Types
      #
      # Types for {Validations::SpiderParams}.
      #
      module Spider
        # The type of web spider targets
        TargetType = Types::String.enum('host', 'domain', 'site')

        # Represents a list of hosts.
        HostList = Types::List

        # Represents a comma separated list of ports.
        PortList = Types::Array.of(Types::Integer).constructor do |value|
          value.split(/(?:,\s*|\s+)/).map(&:to_i)
        end

        # Represents a list of URLs.
        URLList = Types::List

        # Represents a list of file exts.
        ExtList = Types::List
      end
    end
  end
end
