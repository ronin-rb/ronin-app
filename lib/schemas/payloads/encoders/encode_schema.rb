require 'dry/schema'

require 'schemas/params_schema'

module Schemas
  module Payloads
    module Encoders
      #
      # Builds a `Dry::Schema::Params` schema for the given payload encoder
      # class and for the `POST /payloads/encoders/encode...` route.
      #
      # @param [Class<Ronin::Payloads::Encoders::Encode>] encoder_class
      #   The payload encoder class to build the schema for.
      #
      # @return [Dry::Schema::Params]
      #   The built schema.
      #
      def self.EncodeSchema(encoder_class)
        # dynamically encode the dry-schema based on the encoder's params
        params_schema = Schemas::ParamsSchema(encoder_class.params)

        return Dry::Schema::Params() do
          required(:data).filled(:string)
          required(:params).hash(params_schema)
        end
      end
    end
  end
end
