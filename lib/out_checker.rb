require 'bamboo_employee_finder'
require 'days'

class OutChecker
  def initialize(slack_users, bamboo_info_provider)
    @bamboo_info_provider = bamboo_info_provider
    @employee_finder = BambooEmployeeFinder.new(slack_users, bamboo_info_provider.employees)
  end

  def is_out?(slack_id)
    employee_id = @employee_finder.employee_id(slack_id)
    return is_out_on_friday(@bamboo_info_provider.whos_out, employee_id)
  end

  private

  def is_out_on_friday(requests, employee_id)
    requests.each do |request|
      return true if request_for_friday?(request, employee_id)
    end
    false
  end

  def request_for_friday?(request, employee_id)
    return request["employeeId"].to_s == employee_id && contains_a_friday(request["start"], request["end"])
  end

  def date_range(start_date, end_date)
    start = Date.parse(start_date) 
    endd = Date.parse(end_date)
    start..endd
  end

  def contains_a_friday(start_date, end_date)
    date_range(start_date, end_date).each do |day|
      if Days.friday == day
        return true
      end
    end
  end
end
