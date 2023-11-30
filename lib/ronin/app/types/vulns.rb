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
      # Types for {Validations::VulnsParams}.
      #
      module Vulns
        module LFI
          # The type of OS
          OSType = Types::String.enum('unix', 'windows')

          # The lfi filter bypass technique type
          FilterBypassType = Types::String.enum('null_byte', 'double_escape', 'base64', 'rot13', 'zlib')
        end

        module RFI
          # The rfi filter bypass technique type
          FilterBypassType = Types::String.enum('null_byte', 'double_encode')
        end

        module SSTI
          # The type of SSTI escape expression
          EscapeType = Types::String.enum(
            'double_curly_braces',
            'dollar_curly_braces',
            'dollar_double_curly_braces',
            'pound_curly_braces',
            'angle_brackets_percent'
          )
        end
      end
    end
  end
end
