require "sidekiq"

SIDEKIQ_ALT = ConnectionPool.new(size: 1, timeout: 2) { Redis.new(timeout: 1.0) }

Sidekiq.configure_server do |config|
  ActiveRecord::Base.establish_connection
  config.redis = { id: "myweb-server-#{::Process.pid}" }
end

Sidekiq.configure_client do |config|
  config.redis = { id: "myweb-client-#{::Process.pid}" }
end