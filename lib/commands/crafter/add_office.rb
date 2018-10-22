require 'models/apprentice'
require 'models/crafter'
require 'models/office'
require 'office_presenter'
require 'tiny_logger'

module Commands
  class AddOffice
    def applies_to(request)
      request = request[:user_message].downcase
      request.strip.downcase.start_with?("office:")
    end

    def prepare(data)
      @office = Office.new(parse_office_location(data))
      @crafter = Crafter.profile(data[:user_id])
      @apprentice = Apprentice.profile(data[:user_id])
    end

    def parse_office_location(data)
      data[:user_message].gsub("office:", "").strip.downcase
    end

    def updated_crafter
      "#{Crafter.all(:office.not => nil).count}/#{Crafter.all.count}"
    end

    def updated_apprentice
      "#{Apprentice.all(:office.not => nil).count}/#{Apprentice.all.count}"
    end

    def run
      if @office.available? && (@crafter || @apprentice)
        if @crafter
          @crafter.add_office(@office.location)
          Logger.info(
            "#{@office.location} was added to #{@crafter.user_name} - #{updated_crafter}"
          )
        end

        if @apprentice
          @apprentice.add_office(@office.location)
          Logger.info(
            "#{@office.location} was added to #{@apprentice.user_name} - #{updated_apprentice}"
          )
        end

        "You were added to the office: #{@office.location}"
      elsif @crafter || @apprentice
        Logger.info("#{@crafter.user_name} used an unavailable office: #{@office.location}")
        "The offices available are: #{OfficePresenter.locations}"
      else
        ""
      end
    end
  end
end
