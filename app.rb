require 'sinatra'

get '/' do
  system 'rake storia:parse_ads_index'
  "Hello"
end
