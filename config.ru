require './lib/auth'
require './lib/event_controller'

# Initialize the app and create the API (bot) and Auth objects.
run Rack::Cascade.new [EventController, Auth]
$stdout.sync = true
