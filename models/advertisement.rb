class Advertisement
  attr_accessor :price, :currency, :area_square_meters, :price_square_meter, :rooms_number

  def initialize(json_ad)
    self.price = json_ad["totalPrice"]["value"]
    self.currency = json_ad["totalPrice"]["currency"]
    self.area_square_meters = json_ad["areaInSquareMeters"]
    self.price_square_meter = 1.0 * price / area_square_meters
    self.rooms_number = json_ad["roomsNumber"].in_numbers
  end
end
