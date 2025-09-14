require "sidekiq/web" # require the web UI
require "sidekiq/cron/web" # require cron tab UI

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"
  namespace :api do
    resources :routes, only: [:index, :show] do
      resources :trips, only: [:show]
    end
    resources :stops, only: [:index, :show]
    post '/slack', to: 'slack#index'
    post '/slack/query', to: 'slack#query'
    post '/alexa', to: 'alexa#index'
    get '/stats', to: 'stats#index'
  end
  get '/about', to: 'index#index'
  get '/twitter', to: 'index#index'
  get '/trains(/*id)', to: 'index#index'
  get '/stations(/*id)', to: 'index#index'
  get '/oauth', to: 'oauth#index'
  get '/slack', to: 'slack#index'
  get '/slack/help', to: 'slack#help'
  get '/slack/privacy', to: 'slack#privacy'
  get '/slack/install', to: 'oauth#slack_install'
  root 'index#index'
end
