require 'foreman_messager'

class AlertForeman
  def initialize(foreman_messager)
    @foreman_messager = foreman_messager
  end

  def message(text)
    @text = text
    self
  end

  def from(who)
    @who = who
    self
  end

  def send
    @foreman_messager.send(message_format.strip)
  end

  private

  def message_format
    "#{title}\n#{@text}"
  end

  def title
    title = "Something wrong is happening"
    title += " with the #{@who}" if @who
    title
  end
end
