require 'sidekiq'
require 'dry-schema'
require 'types'
require 'types/import'

require 'ronin/nmap/importer'
require 'ronin/masscan/importer'

module Workers
  class Import

    include Sidekiq::Worker
    sidekiq_options queue: :import, retry: false, backtrace: true

    # The accepted JSON params which will be passed to {Import#perform}.
    Params = Dry::Schema::JSON() do
      required(:type).filled(Types::Import::TypeType)
      required(:path).filled(:string)
    end

    # Mapping of importer `type`s and the importer modules.
    IMPORT_TYPES = {
      'nmap'    => Ronin::Nmap::Importer,
      'masscan' => Ronin::Masscan::Importer
    }

    #
    # Processes an `import` job.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    def perform(params)
      kwargs = validate(params)

      type = kwargs[:type]
      path = kwargs[:path]

      importer = IMPORT_TYPES.fetch(type) do
        raise(NotImplementedError,"unsupported import type: #{type.inspect}")
      end

      importer.import_file(path)
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
        raise(ArgumentError,"invalid import params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

  end
end
