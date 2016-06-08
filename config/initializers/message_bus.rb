require 'message_bus'
MessageBus.redis_config = {
  url: ENV['REDIS_URL'] || 'redis://127.0.0.1:6379'
}
