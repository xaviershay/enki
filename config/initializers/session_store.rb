# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_enki_session',
  :secret      => 'd9b13a4ed2cfce88d62a6765b99530fd5a984ac827aa9068bf893aff51233f486c5f57f83d537945fb89caf2cd8bd3f42a5c3bfc5adce818afe28fca0452b52b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
