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