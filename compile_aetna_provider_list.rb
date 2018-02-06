require "./bundler"
require "./capybara"
require "pry"
require "csv"
require "./navigate"
require "./fetch_data"
require "./geocode"

country = "Singapore"
city = ""
username = ""
password = ""
google_api_key = ""

data = Set.new
begin
  login(username, password)
  visit_page("/members/find-healthcare.do")
  fill_in_country_city(country, city)
  pbar = ProgressBar.new(page.find(".pagination-summary span.total").text.to_i)
  loop do
    data += fetch_data
    begin
      pbar.count = data.count
      pbar.write
    rescue
    end
    if got_next_page?
      next_page!
    else
      break
    end
  end
  #geocode_addresses(data, google_api_key)
  write_to_csv(data, to: "aetna.csv")
rescue => e
  screenshot
  binding.pry
  puts "hi"
end
# screenshot
#   binding.pry
#   puts "hi"