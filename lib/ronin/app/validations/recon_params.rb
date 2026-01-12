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

require 'dry/validation'
require 'ronin/recon/value/parser'

module Ronin
  module App
    module Validations
      #
      # Validations for the form params submitted to `POST /recon`.
      #
      class ReconParams < Dry::Validation::Contract

        include Ronin::Recon::Value::Parser

        # Regex to match a value string.
        VALUE_REGEX = /#{IP_RANGE_REGEX}|#{IP_REGEX}|#{WEBSITE_REGEX}|#{WILDCARD_REGEX}|#{HOSTNAME_REGEX}|#{DOMAIN_REGEX}/

        params do
          required(:scope).filled(Types::Args).each(:filled?)

          optional(:ignore).maybe(Types::Args)
          optional(:max_depth).maybe(:integer)
        end

        rule(:scope) do
          bad_values = value.grep_v(VALUE_REGEX)

          unless bad_values.empty?
            key.failure("value must be an IP address, CIDR IP range, domain, sub-domain, wildcard hostname, or website base URL: #{bad_values.join(', ')}")
          end
        end

        rule(:ignore) do
          if value
            bad_values = value.grep_v(VALUE_REGEX)

            unless bad_values.empty?
              key.failure("ignore value must be an IP address, CIDR IP range, domain, sub-domain, wildcard hostname, or website base URL: #{bad_values.join(', ')}")
            end
          end
        end

        rule(:max_depth) do
          if value && value < 2
            key.failure("max_depth must be greater than 1")
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
