require 'coveralls'
require 'data_mapper'
require 'commands/order/set_order_command'

Coveralls.wear!

class Helper
  def self.order(data)
    set_order_command = SetOrderCommand.new
    set_order_command.prepare(data)
    set_order_command.run
  end
end

RSpec.configure do |config|
  DataMapper.setup(:default, 'sqlite::memory:')

  config.before(:each) do
    DataMapper.finalize.auto_migrate!
  end
end

