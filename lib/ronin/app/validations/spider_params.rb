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

require_relative '../types/spider'

require 'dry/validation'

module Ronin
  module App
    module Validations
      #
      # Validations for form params submitted to `POST /web/spider`.
      #
      class SpiderParams < Dry::Validation::Contract

        # Regular expression to loosely validate any hostname (local or DNS).
        HOST_NAME_REGEX = /\A[A-Za-z0-9\._-]+\z/

        params do
          required(:type).filled(Types::Spider::TargetType)
          required(:target).filled(:string)

          optional(:host_header).maybe(:string)
          # optional(:host_headers)
          # optional(:default_headers)
          optional(:user_agent).maybe(:string)
          optional(:referer).maybe(:string)
          optional(:open_timeout).maybe(:integer)
          optional(:read_timeout).maybe(:integer)
          optional(:ssl_timeout).maybe(:integer)
          optional(:continue_timeout).maybe(:integer)
          optional(:keep_alive_timeout).maybe(:integer)
          optional(:proxy).maybe(:string)
          optional(:delay).maybe(:integer)
          optional(:limit).maybe(:integer)
          optional(:max_depth).maybe(:integer)
          optional(:strip_fragments).maybe(:bool)
          optional(:strip_query).maybe(:bool)
          optional(:hosts).maybe(Types::Spider::HostList)
          optional(:ignore_hosts).maybe(Types::Spider::HostList)
          optional(:ports).maybe(Types::Spider::PortList)
          optional(:ignore_ports).maybe(Types::Spider::PortList)
          optional(:urls).maybe(Types::Spider::URLList)
          optional(:ignore_urls).maybe(Types::Spider::URLList)
          optional(:exts).maybe(Types::Spider::ExtList)
          optional(:ignore_exts).maybe(Types::Spider::ExtList)
          optional(:robots).maybe(:bool)

          before(:value_coercer) do |result|
            result.to_h.reject { |key,value| value.empty? }
          end
        end

        rule(:target) do
          case values[:type]
          when 'host'
            unless values[:target] =~ HOST_NAME_REGEX
              key.failure('host must be a valid host name')
            end
          when 'domain'
            unless values[:target] =~ HOST_NAME_REGEX
              key.failure('domain must be a valid host name')
            end
          when 'site'
            unless values[:target] =~ %r{\Ahttp(?:s)?://.+\z}
              key.failure('site must be a valid http:// or https:// URI')
            end
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
