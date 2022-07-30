require 'httparty'
require 'numbers_in_words'
require 'numbers_in_words/duck_punch'
require './models/advertisement'
require 'pry'
require 'pry-nav'

base_url = "https://www.storia.ro/_next/data/Aw6VPVhS0t4d2Tlrs1qax/ro/cautare/inchiriere/apartament/bihor/oradea.json"
page = 1
total_ads = 0
total_price = 0
ads_list = []

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
    puts "-----------------------------\n"

    price_euro = ad.currency == "EUR" ? ad.price : ad.price / 4.94
    total_price += price_euro
    ads_list << ad
  end

  total_ads += ads.count
  page += 1
  break
end

average_price = total_price / total_ads

ads_grouped = ads_list.group_by(&:rooms_number)
ads_with_four_or_more_rooms = []
ads_grouped.each do |rooms_number, ads|
  ads_with_four_or_more_rooms += ads if rooms_number >= 4
end

average_price_1_room = ads_grouped[1].sum{|ad| ad.get_price_in_euro} / ads_grouped[1].count
average_price_2_rooms = ads_grouped[2].sum{|ad| ad.get_price_in_euro} / ads_grouped[2].count
average_price_3_rooms = ads_grouped[3].sum{|ad| ad.get_price_in_euro} / ads_grouped[3].count
average_price_4_rooms = ads_with_four_or_more_rooms.sum{|ad| ad.get_price_in_euro} / ads_with_four_or_more_rooms.count

puts "Total number of ads: #{total_ads}"
puts "Average price: #{average_price}"
puts "Average price one room: #{average_price_1_room}"
puts "Average price two rooms: #{average_price_2_rooms}"
puts "Average price three rooms: #{average_price_3_rooms}"
puts "Average price four+ rooms: #{average_price_4_rooms}"

new_row = [Date.today.to_s, total_ads, average_price, average_price_1_room, average_price_2_rooms, average_price_3_rooms, average_price_4_rooms]
rows = CSV.read("oradea_appartments_rent.csv")

Date.today.to_s == rows[-1][0] ? (rows[-1] = new_row) : rows << new_row

CSV.open("oradea_appartments_rent.csv", "w") do |csv|
  rows.each {|row| csv << row}
end
