# This class represents car to be rented
class Car
  attr_accessor :id, :price_per_day, :price_per_km

  # Create new car instance
  # Params:
  # +params+:: hash row in array of cars from input.json
  def initialize(params)
    @id = params['id']
    @price_per_day = params['price_per_day']
    @price_per_km = params['price_per_km']
  end
end