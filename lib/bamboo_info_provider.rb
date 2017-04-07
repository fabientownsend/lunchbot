require 'httparty'
require 'bamboo_cache'

class BambooInfoProvider
  include HTTParty

  base_uri "https://api.bamboohr.com"

  def initialize(subdomain)
    @subdomain = subdomain
    @api_key = ENV["BAMBOO_HR_API_KEY"]
    @cache = BambooCache.new
  end

  def employees
    @cache.store_employees(get_employees) if @cache.employees_needs_cache?
    @cache.employees
  end

  def whos_out
    @cache.store_whos_out(JSON.parse(whos_out_data.body)) if @cache.whos_out_needs_cache?
    @cache.whos_out
  end

  private

  def get_employees
    JSON.parse(employees_data.body)["employees"]
  end

  def employees_data
    self.class.get("/api/gateway.php/#{@subdomain}/v1/employees/directory", basic_auth: auth_info, headers: headers)
  end

  def whos_out_data
    self.class.get("/api/gateway.php/#{@subdomain}/v1/time_off/whos_out", basic_auth: auth_info, headers: headers)
  end

  def headers
    {'Accept' => 'application/json'}
  end

  def auth_info
    {username: @api_key, password: "x"}
  end
end
