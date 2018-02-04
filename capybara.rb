require "capybara"
require "capybara-webkit"
require 'capybara/dsl'
Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit
include Capybara::DSL
page.driver.header('User-Agent', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0')
def visit_page(path)
  visit("https://int.aetnainternational.com#{path}")
end