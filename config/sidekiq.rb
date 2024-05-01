# frozen_string_literal: true
require 'sidekiq'
require 'redis/namespace'

require_relative '../lib/middleware/sidekiq/active_record_connection_pool'

redis_config = {
  url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}"
}

Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.server_middleware do |chain|
    chain.add Middleware::Sidekiq::ActiveRecordConnectionPool
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.strict_args!(false)
