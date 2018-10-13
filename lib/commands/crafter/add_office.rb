require 'feature_flag'
require 'models/apprentice'
require 'models/crafter'
require 'models/office'
require 'tiny_logger'

module Commands
  class AddOffice < FeatureFlag
    release_for 'Fabien Townsend'

    def applies_to(request)
      if feature_access?(request[:user_name])
        request = request[:user_message].downcase
        request.strip.downcase.start_with?("office:")
      end
    end

    def prepare(data)
      @office = data[:user_message].gsub("office:", "").strip.downcase
      @crafter = Crafter.profile(data[:user_id])
      @apprentice = Apprentice.profile(data[:user_id])
    end

    def run
      if Office.available?(@office)
        @crafter.add_office(@office)
        Logger.info("#{@office} was added to #{@crafter.user_name} - #{updated_crafter}")
        @apprentice.add_office(@office) if @apprentice
        Logger.info("#{@office} was added to #{@apprentice.user_name}") if @apprentice

        "You were added to the office: #{@office}"
      else
        Logger.info("#{@crafter.user_name} use a unavailable office: #{@office}")
        "The office available are: #{Office.list.map(&:capitalize).join(", ")}"
      end
    end
  end

  private

  def updated_crafter
    "#{Crafter.all(:office => !nil).count}/#{Crafter.all.count}"
  end

  def updated_apprentice
    "#{Apprentice.all(:office => !nil).count}/#{Apprentice.all.count}"
  end
end
