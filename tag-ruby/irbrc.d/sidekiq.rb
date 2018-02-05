def sidekiq_clear_all
  require 'sidekiq/api'

  # Clear all queues
  Sidekiq::Queue.all.each(&:clear)

  # Clear all scheduled tasks
  Sidekiq::RetrySet.new.clear
  Sidekiq::ScheduledSet.new.clear
end
