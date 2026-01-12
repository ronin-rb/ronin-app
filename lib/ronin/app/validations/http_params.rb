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

require 'dry/validation'

module Ronin
  module App
    module Validations
      #
      # Validations for the form params submitted to `POST /network/http`.
      #
      class HTTPParams < Dry::Validation::Contract

        HTTPMethods = Types::Symbol.enum(
          copy:      'COPY',
          delete:    'DELETE',
          get:       'GET',
          head:      'HEAD',
          lock:      'LOCK',
          mkcol:     'MKCOL',
          move:      'MOVE',
          options:   'OPTIONS',
          patch:     'PATCH',
          post:      'POST',
          propfind:  'PROPFIND',
          proppatch: 'PROPPATCH',
          put:       'PUT',
          trace:     'TRACE',
          unlock:    'UNLOCK'
        )

        Versions = (Types::Float | Types::Integer).enum(
          1   => '1.0',
          1.1 => '1.1',
          1.2 => '1.2'
        )

        VerificationModes = Types::Symbol.enum(
          none:                 'none',
          peer:                 'peer',
          fail_if_no_peer_cert: 'fail_if_no_peer_cert'
        )

        Headers = Types::Hash.constructor do |input,type|
          if input.is_a?(String)
            headers = {}

            input.strip.each_line(chomp: true) do |line|
              name, value = line.split(/:\s*/,2)

              case (previous_value = headers[name])
              when nil # no value yet
                headers[name] = value
              when String # previous value
                headers[name] = [previous_value, value]
              when Array # multiple previous values
                previous_value << value
              end
            end

            headers unless headers.empty?
          elsif type.valid?(input)
            input
          else
            type.call(input)
          end
        end

        params do
          required(:method).filled(HTTPMethods)
          required(:url).filled(:string)

          optional(:body).maybe(:string)
          optional(:headers).maybe(Headers)

          optional(:proxy).maybe(:string)
          optional(:user_agent).maybe(:string)
          optional(:user).maybe(:string)
          optional(:password).maybe(:string)
          optional(:cookie).maybe(:string)

          optional(:ssl).hash do
            optional(:timeout).maybe(:integer)
            optional(:version).maybe(Versions)
            optional(:min_version).maybe(Versions)
            optional(:max_version).maybe(Versions)
            optional(:verify).maybe(VerificationModes)
            optional(:verify_depth).maybe(:integer)
            optional(:verify_hostname).maybe(:bool)
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
