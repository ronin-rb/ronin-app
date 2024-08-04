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

require_relative '../types/import'

require 'dry/validation'
require 'set'

require 'masscan/output_file'

module Ronin
  module App
    module Validations
      #
      # Validations for the form params submitted to `POST /import`.
      #
      class ImportParams < Dry::Validation::Contract

        params do
          required(:type).filled(Types::Import::TypeType)
          required(:path).filled(:string)
        end

        # Mapping of `type` values to their set of valid file extension names.
        VALID_FILE_EXTS = {
          'nmap'    => Set['.xml'],
          'masscan' => Masscan::OutputFile::FILE_FORMATS.keys.to_set
        }

        rule(:path) do
          valid_file_exts = VALID_FILE_EXTS.fetch(values[:type])

          unless valid_file_exts.include?(File.extname(value))
            key.failure("#{values[:type]} file path must end with #{valid_file_exts.join(', ')}")
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
