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
require 'dry-schema'

require 'tempfile'
require 'nmap/command'
require 'ronin/nmap/importer'

module Workers
  #
  # `nmap` scanner worker.
  #
  class Nmap

    include Sidekiq::Worker
    sidekiq_options queue: :scan, retry: false, backtrace: true

    # The accepted JSON params which will be passed to {Nmap#perform}.
    Params = Dry::Schema::JSON() do
      required(:targets).array(:string)
      optional(:ports).value(:string)
    end

    #
    # Processes an `nmap` job.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    # @raise [RuntimeError]
    #   The `nmap` command failed or is not installed.
    #
    def perform(params)
      kwargs = validate(params)

      Tempfile.open(['nmap-', '.xml']) do |tempfile|
        status = ::Nmap::Command.run(
          **kwargs,
          verbose:    true,
          privileged: true,
          output_xml: tempfile.path
        )

        case status
        when true
          Ronin::Nmap::Importer.import_file(tempfile.path)
        when false
          raise("nmap command failed")
        when nil
          raise("nmap command not installed")
        end
      end
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
