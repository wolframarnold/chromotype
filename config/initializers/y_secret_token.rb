# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

# This relies on an automatically generated Setting that's persisted in your RDBMS:
ActiveSupport.migration_safe_on_load do
  Chromotype::Application.config.secret_token = Setting.secret_token
end
