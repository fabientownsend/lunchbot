require 'bamboo_hr'

class BambooEmployeeFinder
  def initialize(channel_users, bamboo_employees)
    @channel_users = channel_users
    @bamboo_employees = bamboo_employees
  end

  def employee_id(slack_id)
    return employee_data(slack_id)["employeeId"]
  end

  private

  def employee_data(slack_id)
    @channel_users.each do |user|
      if user[:user_id] == slack_id
        return employee_data_for(user)
      end
    end
  end

  def employee_data_for(user)
    @bamboo_employees.each do |employee|
      if are_match(user, employee) 
        return employee
      end
    end
  end

  def are_match(user, employee)
    return user[:email] == employee["workEmail"]
  end
end
