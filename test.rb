require "oauth2"
#require "httplog"

API_KEY = "xx"
API_SECRET = "xx"

client = OAuth2::Client.new(API_KEY, API_SECRET, site: "https://api.os.uk", token_url: "/oauth2/token/v1")

token = client.client_credentials.get_token

#response = token.get("/search/places/v1/postcode", params: {postcode: "E1 8QS", dataset: "LPI"}) # LPI = Local Property Identifier, i.e. all the stuff on a street (e.g. phone masts, bus shelters, phone boxes, etc)
response = token.get("/search/places/v1/postcode", params: {postcode: "E1 8QS", dataset: "DPA"}) # DPA = Delivery Point Addresses, i.e. postal addresses

puts response.body

## Custodian code = LTLA

## If all results have the same custodian code, it's not a split postcode, so just choose the first result
## If some results have a different custodian code, then prompt user to select their address

## Replicate a user selecting a single address, or we could just choose the first address is all results have the same custodian code
one_address = JSON.parse(response.body)["results"].find do |result|
  result.dig("DPA", "ORGANISATION_NAME") =~ /GOVERNMENT DIGITAL SERVICE/
end
puts one_address

## Use the coordinates to get the nearest OS Names API entry, then return the LA details
coordinates = [one_address.dig("DPA", "X_COORDINATE"), one_address.dig("DPA", "Y_COORDINATE")].join(",")
response = token.get("/search/names/v1/nearest", params: {point: coordinates})
puts response.body
