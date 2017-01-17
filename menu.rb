class Menu
  attr_reader :url

  def initialize
    @url = "no link provided"
  end

  def set_url(url)
    @url = url
  end

  def parse_url(text)
    text[/((http|https):\/\/)?(w{3}.)?[A-Za-z0-9-]+.(com|co.uk)/]
  end
end
