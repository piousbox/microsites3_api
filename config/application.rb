require_relative 'boot'

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# ish_models/railtie # doesn't work right now
require_relative "initializers/00_s3.rb"

Bundler.require(*Rails.groups)

module Microsites3Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

  end
end

def json_puts! a, b=''
  puts "+++ #{b}"
  print JSON.pretty_generate( a )
  STDOUT.flush
end

def puts! a, b=''
  puts "+++ #{b}"
  puts a.inspect
end

def print! a, b=''
  puts "+++ #{b}"
  print a
  STDOUT.flush
end
