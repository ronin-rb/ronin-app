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

require 'dry/types'

module Ronin
  module App
    #
    # Types used by `ronin-app`.
    #
    module Types
      include Dry::Types()

      # Represents an Array of argument values.
      Args = Types::Array.of(Types::String).constructor do |value|
        value.split
      end

      # Represents a space or comma separated list of values.
      List = Types::Array.of(Types::String).constructor do |value|
        value.split(/(?:,\s*|\s+)/)
      end

      # Represents a comma separated list of values.
      CommaSeparatedList = Types::Array.of(Types::String).constructor do |value|
        value.split(/,\s*/)
      end

      # Represents an HTTP method name.
      HTTPMethod = Types::String.enum(
        'COPY',
        'DELETE',
        'GET',
        'HEAD',
        'LOCK',
        'MKCOL',
        'MOVE',
        'OPTIONS',
        'PATCH',
        'POST',
        'PROPFIND',
        'PROPPATCH',
        'PUT',
        'TRACE',
        'UNLOCK'
      )
    end
  end
end
