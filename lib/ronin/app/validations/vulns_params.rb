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

require 'dry/validation'
require 'ronin/app/types/spider'

module Ronin
  module App
    module Validations
      #
      # Validations for form params submitted to `POST /vulns`.
      #
      class VulnsParams < Dry::Validation::Contract

        params do
          required(:url).filled(:string)

          optional(:lfi).hash do
            optional(:os).maybe(:string)
            optional(:depth).maybe(:integer)
            optional(:filter_bypass).maybe(:string)
          end

          optional(:rfi).hash  do
            optional(:filter_bypass).maybe(:string)
            optional(:test_script_url).maybe(:string)
          end

          optional(:sqli).hash  do
            optional(:escape_quote).maybe(:bool)
            optional(:escape_parens).maybe(:bool)
            optional(:terminate).maybe(:bool)
          end

          optional(:ssti).hash  do
            optional(:escape).maybe(:string) #?
            optional(:test).maybe(:string) #?
          end

          optional(:open_redirect).hash  do
            optional(:test_url).maybe(:string)
          end
        end

        #
        # Initializes and calls the validation contract.
        #
        # @param [Hash{String => Object}] params
        #   The HTTP params to validate.
        #
        # @return [Dry::Validation::Result]
        #   The validation result.
        #
        def self.call(params)
          new.call(params)
        end

      end
    end
  end
end
