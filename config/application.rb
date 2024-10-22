require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load .env file in development and test environments
if Rails.env.development? || Rails.env.test?
  Dotenv::Railtie.load
end

module App
  class Application < Rails::Application

    config.load_defaults 7.1

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', 
          headers: :any, 
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['Authorization'],
          max_age: 600
      end
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.eager_load_paths -= %W(#{config.root}/lib/assets #{config.root}/lib/tasks)

    # Configuration for the application, engines, and railties goes here.
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
