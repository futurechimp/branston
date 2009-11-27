# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_branston_session',
  :secret      => '8dd6da1924758b31b76c72a064ae7a6f9dc974f99fb287c1884850e851f74dd4ebe2e013496a9ac57c398b53c7621a7dcc080b2d393c7396ce63ef1764cd8aa6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
