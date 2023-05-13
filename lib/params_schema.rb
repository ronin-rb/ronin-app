require 'dry-schema'
require 'types'

#
# Module which can build a `Dry::Schema` from a class'es [params].
#
# [params]: https://ronin-rb.dev/docs/ronin-core/Ronin/Core/Params/Mixin.html
#
module ParamsSchema
  #
  # Builds a `Dry::Schema::Params` schema using a class'es defined params.
  #
  # @param [Hash{Symbol => Ronin::Core::Params::Param}] params
  #   The class'es params.
  #
  def self.build(params)
    dsl = Dry::Schema::DSL.new(processor_type: Dry::Schema::Params)

    params.each do |name,param|
      schema_type = case param.type
                    when Ronin::Core::Params::Types::Enum
                      Types::String.enum(*param.type.values)
                    when Ronin::Core::Params::Types::Boolean
                      :bool
                    when Ronin::Core::Params::Types::Integer
                      :integer
                    when Ronin::Core::Params::Types::Float
                      :float
                    else
                      :string
                    end

      if (param.required? && !param.has_default?)
        dsl.required(name).filled(schema_type)
      else
        dsl.optional(name).maybe(schema_type)
      end
    end

    return dsl.call
  end
end
