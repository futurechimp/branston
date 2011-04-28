# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored

# HEY MORON, IF YOU HAVE PROBLEMS WITH EMAIL ON THE SITE IT'S PROBABLY BECAUSE
# THE APP DOES ITS OWN EMAIL CONFIGURATION IN THE SITE SETTINGS.
#
# Setting action_mailer to use :sendmail delivery, which is working on other sites
# on the same box, doesn't want to work for this one:
#
config.action_mailer.delivery_method = :sendmail

# These settings should cause Rails to throw a nice big stack trace if email
# delivery fails, but actually nothing shows up.
#
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.log_level = Logger::DEBUG

