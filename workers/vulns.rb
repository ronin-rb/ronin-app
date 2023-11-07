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

require 'sidekiq'
require 'ronin/vulns/vuln'

module Workers
  #
  # A worker that updates all [ronin repos][ronin-repos].
  #
  # [ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
  #
  class Vulns

    include Sidekiq::Worker
    sidekiq_options queue: :vulns, retry: false, backtrace: true

    Params = Dry::Schema::JSON() do
      required(:url).filled(:string)
    end

    def perform(params)
      kwargs = validate(params)
      url    = kwargs[:url]

      Ronin::Vulns::URLScanner.scan(url)
    end

    #
    # Validates the given job params.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @return [Hash{Symbol => Object}]
    #   The validated and coerced params as a Symbol Hash.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    def validate(params)
      result = Params.call(params)

      if result.failure?
        raise(ArgumentError,"invalid nmap params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

  end
end
