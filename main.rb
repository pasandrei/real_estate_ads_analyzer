require 'httparty'
require 'numbers_in_words'
require 'numbers_in_words/duck_punch'

base_url = "https://www.storia.ro/_next/data/pgVOGyuLbnviUF3fMMbc8/ro/cautare/inchiriere/apartament/bihor/oradea.json"
page = 1
total_ads = 0

loop do
  url = "#{base_url}?limit=36&page=#{page}"
  response = HTTParty.get(url)

  ads = response["pageProps"]["data"]["searchAds"]["items"]

  break if ads.count.zero?

  ads.each do |ad|
    value = ad["totalPrice"]["value"]
    currency = ad["totalPrice"]["currency"]
    area_in_square_meters = ad["areaInSquareMeters"]
    price_per_square_meter = 1.0 * value / area_in_square_meters
    rooms_number = ad["roomsNumber"]

    puts "#{value} #{currency}"
    puts "Area in square meters: #{area_in_square_meters}"
    puts "Price per square meter: #{price_per_square_meter.round(2)} #{currency}"
    puts "Number of rooms: #{rooms_number.downcase.in_numbers}"
    puts "-----------------------------"
  end

  total_ads += ads.count
  page += 1
  break
end

puts "Total number of ads: #{total_ads}"

