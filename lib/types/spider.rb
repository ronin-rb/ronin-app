require 'dry-types'

module Types
  module Spider
    include Dry::Types()

    # The type of web spider targets
    TargetType = Types::String.enum('host', 'domain', 'site')
  end
end
