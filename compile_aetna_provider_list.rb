require "./bundler"
require "./capybara"
require "pry"
require "csv"

country = "Singapore"
city = ""
username = ""
password = ""
google_api_key = ""


def login(username, password)
  visit_page("/members/login.do")
  sleep(5)

  fill_in("Username", with: username)
  fill_in("Password", with: password)

  click_button("btnSubmit")
  sleep(5)
end

def fill_in_country_city(country, city)
  select(country.upcase, from: "selectedCountry")
  sleep(10)
  select(city, from: "city") if !city.strip.empty?

  click_button "Search"
  sleep(15)
end

def got_next_page?
  !page.all("a.pagination-underline")[-2][:class].include? "disabled"
end

def next_page!
  page.find("a.pagination-underline", text: "Next").click
  sleep(2)
end

def multiline(element, separator)
  element.all("div").map(&:text).select{|s| s.length > 0}.join(separator)
end

def fetch_data
  page.all("tbody tr:first-child").map do |el|
    {
      "name"         => el.all("td")[0].text,
      "address"      => multiline(el.all("td")[1], ", "),
      "type"         => multiline(el.all("td")[2], "\n"),
      "phone_number" => el.all("td")[3].text&.split(".")&.join(" ")
    }
  end
end

def write_to_csv(arr_of_hsh, to:)
  CSV.open(to, "w") do |csv|
    csv << %w(Name Address Description Phone Latitude Longitude)
    arr_of_hsh.each {|hsh| csv << hsh.values_at(*%w(name address type phone_number lat lng))}
  end
end

def geocode_address(address, google_api_key)
  address =URI.encode address #address.sqplit(" ").join("+")
  coords = JSON.parse(Net::HTTP.get(URI.parse "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{google_api_key}"))
  if coords["results"].empty?
    {"lat" => nil, "lng" => nil}
  else
    coords["results"].first["geometry"]["location"]
  end
end

def geocode_addresses(data, google_api_key)
  pbar = ProgressBar.new(data.count)
  data.each do |hsh|
    pbar.increment!
    hsh.merge! geocode_address(hsh["address"], google_api_key)
  end
end

# TODO
# Fix address reliably
# First page downloaded twice

data = []
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
    rescue => e
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
  save_and_open_screenshot
  binding.pry
  puts "hi"
end
# save_and_open_screenshot
#   binding.pry
#   puts "hi"