Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end

Sidekiq::Options[:cron_poll_interval] = 2

Rails.application.reloader.to_prepare do
  Sidekiq::Cron::Job.create(name: 'RoutingRefreshWorker - Every 30 secs', cron: '*/30 * * * * *', class: 'RoutingRefreshWorker')
  Sidekiq::Cron::Job.create(name: 'FeedRetrieverSpawningWorker - Every 5 secs', cron: '*/5 * * * * *', class: 'FeedRetrieverSpawningWorker')
  Sidekiq::Cron::Job.create(name: 'AccessibilityListWorker - Every 5 mins', cron: '*/5 * * * *', class: 'AccessibilityListWorker')
  Sidekiq::Cron::Job.create(name: 'AccessibilityStatusesWorker - Every 5 mins', cron: '*/5 * * * *', class: 'AccessibilityStatusesWorker')
  Sidekiq::Cron::Job.create(name: 'TwitterDelaysNotifierWorker - Every 1 min', cron: '* * * * *', class: 'TwitterDelaysNotifierWorker')
  Sidekiq::Cron::Job.create(name: 'TwitterServiceChangesNotifierWorker - Every 1 min', cron: '* * * * *', class: 'TwitterServiceChangesNotifierWorker')
  Sidekiq::Cron::Job.create(name: 'HerokuAutoscalerWorker - Every 1 min', cron: '* * * * *', class: 'HerokuAutoscalerWorker')
  Sidekiq::Cron::Job.create(name: 'TravelTimesRefreshWorker - Every 2 min', cron: '*/2 * * * *', class: 'TravelTimesRefreshWorker')
  Sidekiq::Cron::Job.create(name: 'ScheduledTimesRefreshWorker - Every 5 min', cron: '*/5 * * * *', class: 'ScheduledTimesRefreshWorker')
  Sidekiq::Cron::Job.create(name: 'RedisCleanupWorker - Every 30 mins', cron: '*/30 * * * *', class: 'RedisCleanupWorker')
end