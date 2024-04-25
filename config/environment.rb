# Load the Rails application.
require_relative "application"
require 'dotenv/rails'

Dotenv.load ".env"

# Initialize the Rails application.
Rails.application.initialize!
