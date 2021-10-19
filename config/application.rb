require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LodqaDb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Ensure Rack::Cors to run before Warden::Manager used by Devise
    config.middleware.insert_before Warden::Manager, Rack::Cors do
        allow do
            origins '*'
            resource '*',
            :headers => :any,
            :methods => [:get, :options]
        end
    end

    config.active_job.queue_adapter = :async
    config.autoload_paths += %W(#{config.root}/app/jobs/concerns)
  end
end
