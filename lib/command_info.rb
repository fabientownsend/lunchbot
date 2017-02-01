module CommandInfo
  def all_command_info
    info_array.join("\n")
  end

  private

  def info_array
    info = [menu_command_info, order_command_info, foreman_command_info, "To remind everyone who hasn't ordered | remind"]
  end

  def menu_command_info
    "To set a menu | new menu www.menu-url.com \nTo get this weeks menu | menu?"
  end

  def order_command_info
    "To place an order| order me: food \nTo see someone elses order | order @name_of_person \nTo see all orders | all orders? \nTo copy someones order | copy order: @username"
  end

  def guest_command_info
    "To add a guest with no order | add guest: name of guest \nTo remove a guest | remove guest: name of guest \nTo place an order for a guest (this also creates if the name does not exist) | order -name of guest-: food"
  end

  def foreman_command_info
    "To find out this weeks foreman | foreman \nTo change this weeks foreman to the next in line | next foreman"
  end
end
