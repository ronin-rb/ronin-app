# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (c) 2023-2024 Hal Brodigan (postmodern.mod3@gmail.com)
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

module Ronin
  module App
    module Types
      #
      # Types for {Validations::VulnsParams}.
      #
      module Vulns
        module LFI
          # The type of OS
          OSType = Types::Symbol.enum(
            unix:    'unix',
            windows: 'windows'
          )

          # The lfi filter bypass technique type
          FilterBypassType = Types::Symbol.enum(
            null_byte:     'null_byte',
            double_escape: 'double_escape',
            base64:        'base64',
            rot13:         'rot13',
            zlib:          'zlib'
          )
        end

        module RFI
          # The rfi filter bypass technique type
          FilterBypassType = Types::Symbol.enum(
            null_byte: 'null_byte',
            double_encode: 'double_encode',
            suffix_escape: 'suffix_escape'
          )
        end

        module SSTI
          # The type of SSTI escape expression
          EscapeType = Types::Symbol.enum(
            double_curly_braces:        'double_curly_braces',
            dollar_curly_braces:        'dollar_curly_braces',
            dollar_double_curly_braces: 'dollar_double_curly_braces',
            pound_curly_braces:         'pound_curly_braces',
            angle_brackets_percent:     'angle_brackets_percent'
          )
        end
      end
    end
  end
end
