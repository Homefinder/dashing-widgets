require 'net/http'
require 'json'

SCHEDULER.every '5m', :first_in => '5s' do |job|
  uri = URI.parse("https://status.heroku.com/api/v3/current-status")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  status = JSON.parse(response.body)
  
  prod_status = status['status']['Production']
  dev_status = status['status']['Development']
  issue_count = status['issues'].size.to_i
  
  send_event("heroku-prod", {status: prod_status, issue_count: issue_count})
  send_event("heroku-dev", {status: dev_status, issue_count: issue_count})
end