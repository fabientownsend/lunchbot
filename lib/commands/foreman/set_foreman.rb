require 'models/apprentice'

module Commands
  class SetForeman
    def applies_to(request)
      request.start_with? "set foreman:"
    end

    def prepare(data)
      request = data[:user_message]
      foreman = format_foreman(request)
      @foreman_id = foreman[/(?<=\<@)(\w+)(?=>)/]
    end

    def run
      if @foreman_id && Apprentice.last(slack_id: @foreman_id)
        sort_apprentice_list
      else
        "That person is not an apprentice!"
      end
    end

    private

    def sort_apprentice_list
      Apprentice.all.each do |apprentice|
        next if apprentice.slack_id == @foreman_id
        move_to_back(apprentice)
      end
      "<@#{@foreman_id}> is now the foreman!"
    end

    def move_to_back(apprentice)
      apprentice.destroy
      recreate(apprentice)
    end

    def recreate(apprentice)
      apprentice = Apprentice.new(
        slack_id: apprentice.slack_id,
        user_name: apprentice.user_name
      )
      apprentice.save
    end

    def format_foreman(request)
      foreman = request.gsub("set foreman:", "")
      foreman[0] = "" if foreman[0] == " "
      foreman
    end
  end
end
