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