require 'models/apprentice'
require 'models/crafter'
require 'models/office'
require 'tiny_logger'

module Commands
  class AddOffice
    def self.add_office_request?(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("office:")
    end

    def applies_to(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("office:")
    end

    def prepare(data)
      @office = data[:user_message].gsub("office:", "").strip.downcase
      @crafter = Crafter.profile(data[:user_id])
      @apprentice = Apprentice.profile(data[:user_id])
    end

    def updated_crafter
      "#{Crafter.all(:office.not => nil).count}/#{Crafter.all.count}"
    end

    def updated_apprentice
      "#{Apprentice.all(:office.not => nil).count}/#{Apprentice.all.count}"
    end

    def run
      if Office.available?(@office) && (@crafter || @apprentice)
        if @crafter
          @crafter.add_office(@office)
          Logger.info("#{@office} was added to #{@crafter.user_name} - #{updated_crafter}")
        end

        if @apprentice
          @apprentice.add_office(@office)
          Logger.info("#{@office} was added to #{@apprentice.user_name} - #{updated_apprentice}")
        end

        "You were added to the office: #{@office}"
      elsif @crafter || @apprentice
        Logger.info("#{@crafter.user_name} use a unavailable office: #{@office}")
        "The office available are: #{Office.list.map(&:capitalize).join(", ")}"
      else
        ""
      end
    end
  end
end
