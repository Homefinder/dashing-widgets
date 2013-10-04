require 'net/http'
require 'json'

api_key = "YOUR API KEY HERE"

def calculate_rate(count, total_sent)
  if total_sent > 0
    "#{((count / total_sent.to_f) * 100).to_i}%"
  else
    "0%"
  end
end

# tags
SCHEDULER.every '5m', :first_in => '1s' do |job|
  uri = URI.parse("https://mandrillapp.com/api/1.0/tags/list.json")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data({"key" => api_key})
  response = http.request(request)  
  parsed_response = JSON.parse(response.body)
  tags = []

  # get list of tags
  parsed_response.each do |tag|
    tags << tag["tag"]
  end

  #now get detail info for each tag
  tags.each do |tag|
    uri = URI.parse("https://mandrillapp.com/api/1.0/tags/info.json")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({key: api_key, tag: tag})
    response = http.request(request)  
    tag_stats = JSON.parse(response.body)
    [tag_stats, tag_stats['stats']['today'], tag_stats['stats']['last_7_days'], tag_stats['stats']['last_30_days']].each do |stats|      
      total_deliveries = stats['sent'] - stats['hard_bounces'] - stats['soft_bounces']
      stats["deliverability"] = calculate_rate(total_deliveries, stats['sent'])
      stats["open_pct"] = calculate_rate(stats['unique_opens'], stats['sent'])
      stats["click_pct"] = calculate_rate(stats['unique_clicks'], stats['sent'])
    end

    send_event(tag, {data: tag_stats})
  end
end