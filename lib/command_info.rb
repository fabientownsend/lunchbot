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
    "To get this week's menu | `menu?`"
  end

  def other
    "To delete a crafter | `delete crafter slack_user_name`"
  end

  def guest
    "To add a guest with no order | `add guest: name of guest`\n" \
    "To remove a guest | `remove guest: name of guest`\n" \
    "To place an order for a guest (this also creates a guest if the name" \
    "given does not exist) | `order -name of guest-: food`"
  end

  def order
    "To place an order | `order: food`\n" \
    "To see all orders | `all orders?`\n" \
    "To copy someone's order | `copy order: @username`"
  end

  def foreman
    "To find out this week's foreman | `foreman`\n" \
    "To add yourself as the new foreman | `add apprentice`" \
    "To remind people with no order | `remind`"
  end

  def issues
    ":bug: Want to report a bug or have an idea for a new feature? :package:\n" \
    "Share it here: :loudspeaker: <https://github.com/fabientownsend/lunchbot/issues/new>" \
    ":loudspeaker:\n" \
    "Join the channel #lunchbot_dev" \
    "\n\n"
  end
end
