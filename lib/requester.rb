require 'user_info_provider'

module SlackApi
  class Requester
    attr_reader :message
    attr_reader :id
    attr_reader :name
    attr_reader :email

    def initialize(args, slack_api_user: UserInfoProvider.new)
      @message = clean(args['event']['text'])
      @id = args['event']['user']
      @name = slack_api_user.real_name(args['event']['user'])
      @email = slack_api_user.email(args['event']['user'])
    end

    private

    def clean(data)
      data.strip.downcase
    end
  end
end
