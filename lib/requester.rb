# typed: true
require 'user_info_provider'

module SlackApi
  class Requester
    attr_reader :email
    attr_reader :id
    attr_reader :message
    attr_reader :name
    attr_reader :recipient

    def initialize(slack_api_user: UserInfoProvider.new)
      @slack_api_user = slack_api_user
    end

    def parse(slack_parameters)
      @email = slack_api_user.email(slack_parameters['event']['user'])
      @id = slack_parameters['event']['user']
      @message = clean(slack_parameters['event']['text'] || "")
      @name = slack_api_user.real_name(slack_parameters['event']['user'])
      @recipient = slack_parameters['event']['channel'] || slack_parameters['event']['user']
    end

    def has_message?
      message != ""
    end

    private

    attr_reader :slack_api_user

    def clean(data)
      data.strip
    end
  end
end
