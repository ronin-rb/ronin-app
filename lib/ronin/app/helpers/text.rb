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

require 'ronin/core/cli/text/arch'
require 'ronin/core/cli/text/os'
require 'ronin/core/cli/text/params'
require 'ronin/payloads/cli/text'
require 'ronin/vulns/cli/text'
require 'ronin/exploits/cli/text'

module Ronin
  module App
    module Helpers
      #
      # Text helper methods.
      #
      module Text
        include Core::CLI::Text::Arch
        include Core::CLI::Text::OS
        include Core::CLI::Text::Params
        include Payloads::CLI::Text
        include Vulns::CLI::Text
        include Exploits::CLI::Text
      end
    end
  end
end
