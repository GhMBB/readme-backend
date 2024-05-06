require_relative "boot"

require "rails/all"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReadmeBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))
    config.cloudinary_cloud_name = 'dkrmah0f7'
    config.cloudinary_api_key = '183549582925518'

    config.secret_key = ENV['SECRET_KEY']
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    #config.i18n.default_locale = :es
  #  config.action_dispatch.default_headers['X-Frame-Options'] = 'SAMEORIGIN'
   # config.action_dispatch.default_headers['X-Content-Type-Options'] = 'nosniff'
   # config.action_dispatch.default_headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
   # config.action_dispatch.default_headers['Permissions-Policy'] = "geolocation=(self #{ENV['FRONT_URL']})"
    # Configuración de Content-Security-Policy (CSP)
  #  config.content_security_policy do |policy|
    #  policy.default_src :self
    #  policy.script_src :self, :https
    #  policy.style_src :self, :https
     # policy.img_src :self, :https, :data
    #end
  end
end
