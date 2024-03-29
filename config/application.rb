require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BreadCoop
  class Application < Rails::Application
    config.stripe.secret_key = Rails.env.production? ?  ENV["STRIPE_API_KEY"] : "sk_test_DqjO0gKgUXChnkZ7379iu6dw"
    config.stripe.publishable_key = Rails.env.production? ?  ENV["STRIPE_PUBLIC_KEY"] : "pk_test_VERKszwCAQv7IqZALmcmQzIU"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'
    config.active_record.default_timezone = :local


    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'en-GB'

    config.generators do |g|
      g.view_specs false
      g.assets = false
      g.helper  false
    end
  end
end
