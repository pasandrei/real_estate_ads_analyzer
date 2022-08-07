require 'httparty'
require 'numbers_in_words'
require 'numbers_in_words/duck_punch'
require './models/advertisement'
require 'pry'
require 'pry-nav'
require 'aws-sdk-s3'
require 'dotenv/load'

namespace :storia do
  task :parse_ads_index do
    base_url = "https://www.storia.ro/_next/data/Vj57McNjVinJxB6MPDt9K/ro/cautare/inchiriere/apartament/bihor/oradea.json"
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

    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])

    bucket_name = "ro-real-estate-prices-history"
    object_key = 'my-oradea_appartments_rent.csv'
    region = 'eu-north-1'
    s3_client = Aws::S3::Client.new(region: region, credentials: credentials)

    response = s3_client.get_object(
      bucket: bucket_name,
      key: object_key
    )

    rows = CSV.parse(response.body.read)
    Date.today.to_s == (rows&.count > 0 && rows[-1][0]) ? (rows[-1] = new_row) : rows << new_row

    csv_string = CSV.generate do |csv|
      rows.each {|row| csv << row}
    end

    s3_client.put_object(
      bucket: bucket_name,
      key: object_key,
      body: csv_string
    )
  end
end