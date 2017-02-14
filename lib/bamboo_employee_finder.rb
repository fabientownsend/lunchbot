class BambooEmployeeFinder
  def initialize(channel_users, bamboo_employees)
    @channel_users = channel_users
    @bamboo_employees = bamboo_employees
  end

  def employee_id(slack_id)
    return employee_data(slack_id, "id")
  end

  private

  def employee_data(slack_id, data_wanted)
    @channel_users.each do |user|
      if user.slack_id == slack_id
        employee = @bamboo_employees.find {|employee| have_same_email(user, employee)}
        return employee[data_wanted] if !employee.nil?
      end
    end
    "User does not exist in the channel!"
  end

  def have_same_email(user, employee)
    user.email == employee["workEmail"]
  end
end
