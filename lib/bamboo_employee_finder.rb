class BambooEmployeeFinder
  def initialize(channel_users, bamboo_employees)
    @channel_users = channel_users
    @bamboo_employees = bamboo_employees
  end

  def employee_id(slack_id)
    return employee_data(slack_id, "employeeId")
  end

  private

  def employee_data(slack_id, data_wanted)
    @channel_users.each do |user|
      if user[:user_id] == slack_id
        return specific_data(user, data_wanted)
      end
      return "User does not exist in the channel!"
    end
  end

  def specific_data(user, data_wanted)
    employee = employee_data_for(user)
    return employee[data_wanted]
  end

  def employee_data_for(user)
    @bamboo_employees.each do |employee|
      return employee if have_same_email(user, employee) 
    end
  end

  def have_same_email(user, employee)
    return user[:email] == employee["workEmail"]
  end
end
