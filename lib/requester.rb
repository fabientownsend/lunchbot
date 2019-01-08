require 'user_info_provider'

module SlackApi
  class Requester
    attr_reader :message
    attr_reader :id
    attr_reader :name
    attr_reader :email

    def initialize(slack_api_user: UserInfoProvider.new)
      @slack_api_user = slack_api_user
    end

    def parse(args)
      @message = clean(args['event']['text'] || "")
      @id = args['event']['user']
      @name = slack_api_user.real_name(args['event']['user'])
      @email = slack_api_user.email(args['event']['user'])
    end

    def has_message?
      !message.empty?
    end

    private

    attr_reader :slack_api_user

    def clean(data)
      data.strip.downcase
    end
  end
end
