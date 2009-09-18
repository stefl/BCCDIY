# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bccwebsite_session',
  :secret      => '4e6e9a28d84e97199b4a0a49f74d6fb71e16dfa9b08b2a049aee7c949d1a8e49c6aa0a5885e5b716688f8a0975d2dd326e41dc3ce8d48584b9f5ef56980faaa9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
