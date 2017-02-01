module CommandInfo
  def all_command_info
    "To remind everyone who hasn't orders| remind \n"
    + guest_command_info
    + foreman_command_info
    + menu_command_info
  end

  private

  def menu_command_info
    "To set a menu| new menu www.menu-url.com \n
    To get the menu| menu? \n"
  end

  def order_command_info
    "To place an order| order me: food \n
    To see someone elses order| order @name_of_person \n
    To see all orders| all orders? \n"
  end

  def guest_command_info
    "To add a guest with no order| add guest: name of guest \n
    To remove a guest| remove guest: name of guest \n
    To place an order for a guest (this also creates if the name does not exist)| order -name of guest-: food \n"
  end

  def foreman_command_info
    "To find out the weeks foreman| foreman \n
    To get a new foreman of the week| next foreman \n"
  end
end
