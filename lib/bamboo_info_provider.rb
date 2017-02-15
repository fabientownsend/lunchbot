require 'httparty'

class BambooInfoProvider
  include HTTParty

  base_uri "https://api.bamboohr.com"

  def initialize(subdomain)
    @subdomain = subdomain
    @api_key = ENV["BAMBOO_HR_API_KEY"]
    if @api_key.nil?
      raise "Invalid API key! Have you set one?"
    end
  end

  def employees
    data = JSON.parse(employees_data.body)
    data["employees"]
  end

  def whos_out
    JSON.parse(whos_out_data.body)
  end

  private

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
