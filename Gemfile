source 'http://rubygems.org'
ruby '2.5.5'

gem 'coveralls', require: false
gem 'httparty'
gem "rack", ">= 1.6.11"
gem 'sinatra', '~> 2.2.3'
gem 'slack-ruby-client', '~> 0.13.1'
gem 'honeycomb-beeline'

gem 'data_mapper'
gem 'dm-core'

gem "sentry-raven"
gem 'logglier', '~> 0.2.11'

group :test, :development do
  gem 'dm-sqlite-adapter', '1.2.0'
  gem 'pry'
  gem 'rspec', '~> 3.0'
  gem 'rubocop-airbnb', '2.0.0'
  gem 'rack-test'
  gem 'sqlite3', '1.3.13'
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'pg'
end
