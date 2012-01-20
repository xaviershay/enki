source 'https://rubygems.org'

gem 'rails', '3.2.0.rc2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

platforms :ruby do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'trinidad'
  gem 'jruby-openssl'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'RedCloth', '~> 4.2.9', :require => 'redcloth'
gem 'ruby-openid', :require => 'openid'
gem 'rack-openid', :require => 'rack/openid'
gem 'aaronh-chronic', :require => 'chronic' # Fixes for 1.9.2
gem 'coderay'
gem 'lesstile'
gem 'formtastic'
gem 'will_paginate', '~> 3.0.2'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber-websteps'
  gem 'factory_girl'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'nokogiri', '~> 1.5.0'
end
