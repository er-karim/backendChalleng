require 'date'

class Rental

  attr_accessor :id, :car, :start_date, :end_date, :distance

  FIRST_DISCOUNT = 0.1
  SECOND_DISCOUNT = 0.3
  THIRD_DISCOUNT = 0.5

  def initialize(params, cars)
    @id = params['id']
    @car = cars[params['car_id']]
    @start_date = Date.parse params['start_date']
    @end_date = Date.parse params['end_date']
    @distance = params['distance']
  end

  def price
    rental_days = 1 + (@end_date - @start_date).to_i

    price_per_day = @car.price_per_day - (@car.price_per_day * get_discount(rental_days))

    price = rental_days * price_per_day + (@distance * @car.price_per_km)
    {id: @id, price: price.to_i}
  end

  private

  def get_discount(rental_days)
    case rental_days
      when 0..1
        0
      when 2..4
        FIRST_DISCOUNT
      when 5..10
        SECOND_DISCOUNT
      else
        THIRD_DISCOUNT
    end
  end
end