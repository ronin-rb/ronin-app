require 'types'

module Types
  module Spider
    # The type of web spider targets
    TargetType = Types::String.enum('host', 'domain', 'site')
  end
end
