require 'bamboo_employee_finder'
require 'days'
require 'date'

class OutChecker
  def initialize(slack_users, bamboo_info_provider)
    @bamboo_info_provider = bamboo_info_provider
    @employee_finder = BambooEmployeeFinder.new(
      slack_users,
      bamboo_info_provider.employees
    )
  end

  def out?(slack_id)
    user(slack_id).out_friday?
  end

  def user(slack_id)
    @bamboo_id = @employee_finder.employee_id(slack_id)
    self
  end

  def out_friday?
    employee = bamboohr_info(@bamboo_id)
    !employee.nil? && days_off(employee).any?(&:friday?)
  end

  def bamboohr_info(bamboo_id)
    bamboo_calendar = @bamboo_info_provider.whos_out
    bamboo_calendar.detect { |calendar| calendar["employeeId"] == bamboo_id }
  end

  def days_off(employee_info)
    Date.parse(employee_info["start"])..Date.parse(employee_info["end"])
  end
end
