module CommandInfo
  def all_command_info
    info_array.join("\n")
  end

  private

  def info_array
    [issues, menu, order, foreman, other, guest]
  end

  def menu
    "To set a menu | `new menu www.menu-url.com`\n" \
    "To get this weeks menu | `menu?`"
  end

  def other
    "To remind everyone who hasn't ordered | `remind`\n" \
    "To mark yourself as out | `out`"
  end

  def order
    "To place an order | `order: food`\n" \
    "To see someone elses order | `order? @name_of_person`\n" \
    "To see all orders | `all orders?`\n" \
    "To see all orders with user ids | `everyone`\n" \
    "To see sum of orders | `all food orders`\n" \
    "To copy someones order | `copy order: @username`"
  end

  def guest
    "To add a guest with no order | `add guest: name of guest`\n" \
    "To remove a guest | `remove guest: name of guest`\n" \
    "To place an order for a guest (this also creates a guest if the name" \
    "given does not exist) | `order -name of guest-: food`"
  end

  def foreman
    "To find out this weeks foreman | `foreman`\n" \
    "To change this weeks foreman to the next in line | `next foreman`"
  end

  def issues
    ":bug: Want to report a bug or have an idea for a new feature? :package:\n" \
    "Share it here: :loudspeaker: <https://github.com/fabientownsend/lunchbot/issues/new>" \
    ":loudspeaker:" \
    "\n\n"
  end
end
