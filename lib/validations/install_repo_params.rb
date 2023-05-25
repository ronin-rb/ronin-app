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

require 'uri'

module Validations
  #
  # Validations for form params submitted to `POST /repos/install`.
  #
  class InstallRepoParams < Dry::Validation::Contract

    params do
      required(:uri).filled(:string)
      optional(:name).maybe(:string)
    end

    # Regular expression that matches both `https://` URIs and
    # `git@host.com:path/to/repo.git` URIs.
    GIT_URI_REGEX = %r{\A(?:#{URI.regexp(%w[https http git ssh])}|[^@]+@[A-Za-z0-9._-]+(?::\d+)?:[A-Za-z0-9./_-]+)\z}

    rule(:uri) do
      unless value =~ GIT_URI_REGEX
        key.failure('URI must be a https:// or a git@host:path/to/repo.git URI')
      end
    end

    # Regular expression that matches an alpha-numeric name containing dashes
    # and/or underscores.
    NAME_REGEX = /\A[A-Za-z0-9_-]+\z/

    rule(:name) do
      if value && value !~ NAME_REGEX
        key.failure('repo name must only contain alpha-numeric, dashes, and underscores')
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
