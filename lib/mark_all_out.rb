require 'bamboo_info_provider'
require 'commands/order/mark_out'
require 'models/crafter'
require 'out_checker'

class MarkAllOut
  def initialize
    @mark_out = Commands::MarkOut.new
  end

  def update
    out_checker = OutChecker.new(Crafter.all, BambooInfoProvider.new("8thlight"))
    Crafter.all.each do |crafter|
      if out_checker.is_out?(crafter.slack_id)
        @mark_out.prepare({user_id: crafter.slack_id, user_name: crafter.user_name})
        @mark_out.run
      end
    end
  end
end
