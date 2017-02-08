require 'bamboo_hr'

class BambooEmployeeFinder //TODO REFACTOR
  def initialize(channel_users, bamboo_employees)
    @channel_users = channel_users
    @bamboo_employees = bamboo_employees
  end

  def find_employee(slack_id)
    @channel_users.each do |user|
      if find_bamboo_info(user, slack_id)
        return true
      end
      return false
    end
  end

  private

  def find_bamboo_info(user, slack_id)
    @bamboo_employees.each do |employee|
      if user[:user_id] == slack_id and are_match(user, employee)
        return true
      end
      return false
    end 
  end

  def are_match(user, employee)
    if user[:email] == employee["workEmail"]
      return true
    end
  end
end
