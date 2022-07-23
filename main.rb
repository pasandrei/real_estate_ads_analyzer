require 'httparty'
require 'numbers_in_words'
require 'numbers_in_words/duck_punch'
require './models/advertisement'

base_url = "https://www.storia.ro/_next/data/pgVOGyuLbnviUF3fMMbc8/ro/cautare/inchiriere/apartament/bihor/oradea.json"
page = 1
total_ads = 0

loop do
  url = "#{base_url}?limit=36&page=#{page}"
  response = HTTParty.get(url)

  ads = response["pageProps"]["data"]["searchAds"]["items"]

  break if ads.count.zero?

  ads.each do |json_ad|
    ad = Advertisement.new(json_ad)

    puts "#{ad.price} #{ad.currency}"
    puts "Area in square meters: #{ad.area_square_meters}"
    puts "Price per square meter: #{ad.price_square_meter.round(2)} #{ad.currency}"
    puts "Number of rooms: #{ad.rooms_number}"
    puts "-----------------------------"
  end

  total_ads += ads.count
  page += 1
  break
end

puts "Total number of ads: #{total_ads}"

