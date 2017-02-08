source 'http://rubygems.org'
ruby '2.3.1'

gem 'sinatra', '~> 1.4.7'
gem 'slack-ruby-client', '~> 0.7.7'
gem 'rake'
gem 'rspec', '~> 3.0'
gem 'coveralls', require: false
gem 'httparty' 

gem 'data_mapper'
gem 'dm-core'

group :test, :development do
  gem 'sqlite3', '1.3.13'
  gem 'dm-sqlite-adapter', '1.2.0'
end

group :production do
  gem 'dm-postgres-adapter'
  gem 'pg'
end
