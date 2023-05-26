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

require 'schemas/params_schema'

module Schemas
  module Payloads
    #
    # Builds a `Dry::Schema::Params` schema for the given payload class and for
    # the `POST /payloads/.../build` route.
    #
    # @param [Class<Ronin::Payloads::Payload>] payload_class
    #   The payload class to build the schema for.
    #
    # @return [Dry::Schema::Params]
    #   The built schema.
    #
    def self.BuildSchema(payload_class)
      # dynamically build the dry-schema based on the payload's params
      params_schema = Schemas::ParamsSchema(payload_class.params)

      return Dry::Schema::Params() do
        unless payload_class.params.empty?
          required(:params).hash(params_schema)
        end
      end
    end
  end
end
