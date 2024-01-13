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

require 'dry/validation'
require 'ronin/app/types/vulns'

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
            optional(:os).maybe(Types::Vulns::LFI::OSType)
            optional(:depth).maybe(:integer)
            optional(:filter_bypass).maybe(Types::Vulns::LFI::FilterBypassType)
          end

          optional(:rfi).hash do
            optional(:filter_bypass).maybe(Types::Vulns::RFI::FilterBypassType)
            optional(:test_script_url).maybe(:string)
          end

          optional(:sqli).hash do
            optional(:escape_quote).maybe(:bool)
            optional(:escape_parens).maybe(:bool)
            optional(:terminate).maybe(:bool)
          end

          optional(:ssti).hash do
            optional(:escape).maybe(Types::Vulns::SSTI::EscapeType)
          end

          optional(:command_injection).hash do
            optional(:escape_quote).maybe(:string)
            optional(:escape_operator).maybe(:string)
            optional(:terminate).maybe(:string)
          end

          optional(:open_redirect).hash do
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
