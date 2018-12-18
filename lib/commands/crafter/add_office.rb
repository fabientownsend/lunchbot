require 'models/apprentice'
require 'models/user'
require 'models/office'
require 'tiny_logger'

module Commands
  class AddOffice
    def self.description
    end

    def self.add_office_request?(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("office:")
    end

    def applies_to?(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("office:")
    end

    def prepare(data)
      @office = Office.new(parse_office_location(data))
      @user = User.profile(data[:user_id])
    end

    def run
      return ""                 unless @user
      return office_unavailable unless @office.available?

      if @user
        @user.add_office(@office.location)
        log_office_added
      end

      "You were added to the office: #{@office.location}"
    end

    private

    def log_office_added
      Logger.info(
        "#{@office.location} was added to #{@user.user_name}"
      )
    end

    def office_unavailable
      Logger.info("#{@user.user_name} used an unavailable office: #{@office.location}")
      "The offices available are: #{Office.locations.map(&:capitalize).join(", ")}"
    end

    def parse_office_location(data)
      data[:user_message].gsub("office:", "").strip.downcase
    end
  end
end
