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

require 'schemas/masscan_params'

require 'tempfile'
require 'masscan/command'
require 'ronin/masscan/importer'

module Workers
  #
  # `masscan` scanner worker.
  #
  class Masscan

    include Sidekiq::Worker
    sidekiq_options queue: :scan, retry: false, backtrace: true

    Params = Dry::Schema::JSON(parent: Schemas::MasscanParams)

    #
    # Processes an `masscan` job.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    # @raise [RuntimeError]
    #   The `masscan` command failed or is not installed.
    #
    def perform(params)
      kwargs = validate(params)

      Tempfile.open(['masscan-', '.bin']) do |tempfile|
        status = ::Masscan::Command.run(
          **kwargs,
          interactive:   true,
          output_format: :bin,
          output_file:   tempfile.path
        )

        case status
        when true
          Ronin::Masscan::Importer.import_file(tempfile.path)
        when false
          raise("masscan command failed")
        when nil
          raise("masscan command not installed")
        end
      end

      output_file = Ronin::Masscan.scan(**params)

      Ronin::Masscan::Importer.import(output_file)
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
        raise(ArgumentError,"invalid masscan params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

  end
end
