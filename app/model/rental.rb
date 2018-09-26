require 'date'

class Rental

  attr_accessor :id, :car, :start_date, :end_date, :distance

  def initialize(params, cars)
    @id = params['id']
    @car = cars[params['car_id']]
    @start_date = Date.parse params['start_date']
    @end_date = Date.parse params['end_date']
    @distance = params['distance']
  end

  def price
    price = ((@end_date - @start_date) + 1) * @car.price_per_day + (@distance * @car.price_per_km)
    {id: @id, price: price.to_i}
  end

end