require './lib/auth'
require './lib/event_controller'
require 'data_mapper'
require 'dm-core'

require 'raven'
Raven.configure do |config|
  config.dsn = ENV['SENTRY_URL']
end

require 'honeycomb-beeline'
Honeycomb.init(
  writekey: ENV['HONEYCOMB_WRITEKEY'],
  dataset: ENV['HONEYCOMB_DATASET']
)

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

use Raven::Rack

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize.auto_upgrade!
DataMapper::Property::String.length(255)

# Initialize the app and create the API (bot) and Auth objects.
run Rack::Cascade.new [EventController, Auth]
$stdout.sync = true
