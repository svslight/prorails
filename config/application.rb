require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prorails
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    # config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # sidekiq - инструмент для фоновых задач, использует Redis в качестве БД
    config.active_job.queue_adapter = :sidekiq
    
    config.autoload_paths += [config.root.join('app')]

    # config.time_zone = 'Moscow'
    # config.time_zone = 'Eastern Time (US & Canada)' 

    # config.action_cable.disable_request_forgery_protection = false

    # Setting up a Rails generator for controllers
    config.generators do |g|
      g.test_framework :rspec,
                        fixtures: true,
                        view_specs: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false,
                        controller_specs: true
    end 
  end
end
