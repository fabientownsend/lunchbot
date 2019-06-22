# typed: true
require 'bamboo_info_provider'
require 'commands/order/mark_out'
require 'models/user'
require 'out_checker'

class MarkAllOut
  def initialize
    @mark_out = Commands::MarkOut.new
  end

  def update
    raise "Invalid API key! Have you set one?" if ENV["BAMBOO_HR_API_KEY"].nil?
    out_checker = OutChecker.new(User.all, BambooInfoProvider.new("8thlight"))
    User.all.each do |user|
      if out_checker.out?(user.slack_id)
        @mark_out.prepare({ user_id: user.slack_id, user_name: user.user_name })
        @mark_out.run
      end
    end
  end
end
