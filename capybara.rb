require 'capybara/poltergeist'
require 'capybara/dsl'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 90 ,:phantomjs_options => ['--load-images=yes' ,'--ssl-protocol=any','--ignore-ssl-errors=true'])
end
Capybara.default_driver =  :poltergeist#:selenium
include Capybara::DSL
page.driver.headers  = {'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0'}
def visit_page(path)
  visit("https://int.aetnainternational.com#{path}")
end