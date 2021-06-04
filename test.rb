require "oauth2"
#require "httplog"

API_KEY = "xx"
API_SECRET = "xx"

client = OAuth2::Client.new(API_KEY, API_SECRET, site: "https://api.os.uk", token_url: "/oauth2/token/v1")

token = client.client_credentials.get_token

response = token.get("/search/places/v1/postcode", params: {postcode: "E1 8QS"})

puts response.parsed
