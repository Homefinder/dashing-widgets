require 'net/http'
require 'json'

# pass in limit: 5 to get the top 5 errors
def get_honeybadger_errors(options = {})
  api_token = "YOUR API TOKEN HERE"
  project_id = "YOUR PROJECT ID HERE"

  url = "https://api.honeybadger.io/v1/projects/#{project_id}/faults?auth_token=#{api_token}"
  if options[:order]
    url += "&order=#{options[:order]}"
  end

	uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri, {'Accept' => 'application/json', 'Content-Type' => 'application/json'})
  response = http.request(request)
  json_response = JSON.parse(response.body)
  
  upper_bound = options[:limit] || 5
  
  json_response['results'][0..(upper_bound - 1)]
end

SCHEDULER.every '10s', :first_in => 0 do |job|  
  # pass in your own limit, or let it default to 5
  top_five_faults = get_honeybadger_errors(order: "frequent")
  recent_five_faults = get_honeybadger_errors(order: "recent")

  send_event('most_freq_fault', {errors: top_five_faults})
  send_event('most_recent_fault', {errors: recent_five_faults})
end

