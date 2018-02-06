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
    tds = el.all("td")
    {
      "name"         => tds[0].text,
      "map_address"  => tds[1].first("div").text + ", Singapore",
      "address"      => multiline(tds[1], ", "),
      "type"         => multiline(tds[2], "\n"),
      "phone_number" => tds[3].text&.split(".")&.join(" ")
    }
  end
end

def write_to_csv(arr_of_hsh, to:)
  CSV.open(to, "w") do |csv|
    csv << %w(Name MapAddress Address Description Phone) # Latitude Longitude
    arr_of_hsh.each {|hsh| csv << hsh.values_at(*%w(name map_address address type phone_number))} #  lat lng
  end
end