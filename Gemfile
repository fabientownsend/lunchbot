source 'http://rubygems.org'
ruby '2.5.5'

gem "rack", ">= 1.6.11"
gem 'coveralls', require: false
gem 'data_mapper'
gem 'dm-core'
gem 'honeycomb-beeline'
gem 'httparty'
gem 'sinatra', '~> 1.4.7'
gem 'slack-ruby-client', '~> 0.13.1'
gem 'sorbet-runtime'

gem "sentry-raven"
gem 'logglier', '~> 0.2.11'

group :test, :development do
  gem 'dm-sqlite-adapter', '1.2.0'
  gem 'pry'
  gem 'rack-test'
  gem 'rspec', '~> 3.0'
  gem 'rubocop-airbnb', '2.0.0'
  gem 'sorbet'
  gem 'sqlite3', '1.3.13'
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'pg'
end
