require './lib/auth'
require './lib/event_controller'
require 'data_mapper'
require 'dm-core'

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize.auto_upgrade!
DataMapper::Property::String.length(255)

# Initialize the app and create the API (bot) and Auth objects.
run Rack::Cascade.new [EventController, Auth]
$stdout.sync = true
