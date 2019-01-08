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

    def parse(args)
      @email = slack_api_user.email(args['event']['user'])
      @id = args['event']['user']
      @message = clean(args['event']['text'] || "")
      @name = slack_api_user.real_name(args['event']['user'])
      @recipient = args['event']['channel'] || args['event']['user']
    end

    def has_message?
      message != ""
    end

    private

    attr_reader :slack_api_user

    def clean(data)
      data.strip.downcase
    end
  end
end
