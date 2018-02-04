require "./capybara"
require "pry"

country = "Singapore"
city = ""
username = ""
password = ""


def login(username, password)
  visit_page("/members/login.do")

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

login(username, password)
visit_page("/members/find-healthcare.do")
fill_in_country_city(country, city)
save_and_open_screenshot
binding.pry
puts "hi"