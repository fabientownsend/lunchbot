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
    crafter(slack_id).out_friday?
  end

  def crafter(slack_id)
    @bamboo_id = @employee_finder.employee_id(slack_id)
    self
  end

  def out_friday?
    employee_info = bamboohr_info(@bamboo_id)
    return false unless employee_info
    days_off(employee_info).any?(&:friday?)
  end

  def bamboohr_info(bamboo_id)
    bamboo_calandar = @bamboo_info_provider.whos_out
    bamboo_calandar.detect { |calandar| calandar["employeeId"] == bamboo_id }
  end

  def days_off(employee_info)
    Date.parse(employee_info["start"])..Date.parse(employee_info["end"])
  end
end
