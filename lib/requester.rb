module SlackApi
  class Requester
    attr_reader :message
    attr_reader :user_id

    def initialize(args)
      # do we need the data: user_name, user_email?
      # channel_id is unused
      # mark all out should not work for madison

      # if user_name/email useful we should fetch from db
      # then fetch from slack api

      @message = clean(args['event']['text'])
      @user_id = args['event']['user']
    end

    private

    def clean(data)
      data.strip.downcase
    end
  end
end
