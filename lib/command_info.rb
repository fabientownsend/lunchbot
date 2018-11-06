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
    "To delete a crafter | `delete crafter slack_user_name`"
  end

  def order
    "To place an order | `order: food`\n" \
    "To see someone elses order | `order? @name_of_person`\n" \
    "To see all orders | `all orders?`\n" \
    "To copy someones order | `copy order: @username`"
  end

  def foreman
    "To find out this weeks foreman | `foreman`\n" \
    "To add yourself as a new forman | `add apprentice`"
  end

  def issues
    ":bug: Want to report a bug or have an idea for a new feature? :package:\n" \
    "Share it here: :loudspeaker: <https://github.com/fabientownsend/lunchbot/issues/new>" \
    ":loudspeaker:\n" \
    "Join the channel #lunchbot_dev" \
    "\n\n"
  end
end
