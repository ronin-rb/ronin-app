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

require 'dry-schema'
require 'ronin/core/params/types'

module Ronin
  module App
    #
    # Contains class methods for building dynamic dry-schemas.
    #
    module Schemas
      #
      # Builds a `Dry::Schema::Params` schema using a class'es defined params.
      #
      # @param [Hash{Symbol => Ronin::Core::Params::Param}] params
      #   The class'es params.
      #
      def self.ParamsSchema(params)
        dsl = Dry::Schema::DSL.new(processor_type: Dry::Schema::Params)

        params.each do |name,param|
          schema_type = case param.type
                        when Ronin::Core::Params::Types::Enum
                          Types::String.enum(*param.type.values)
                        when Ronin::Core::Params::Types::Boolean
                          :bool
                        when Ronin::Core::Params::Types::Integer
                          :integer
                        when Ronin::Core::Params::Types::Float
                          :float
                        else
                          :string
                        end

          if (param.required? && !param.has_default?)
            dsl.required(name).filled(schema_type)
          else
            dsl.optional(name).maybe(schema_type)
          end
        end

        return dsl.call
      end
    end
  end
end
