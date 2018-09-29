require 'date'

class Rental

  attr_accessor :id, :car, :start_date, :end_date, :distance, :commission

  FIRST_DISCOUNT = 0.1
  SECOND_DISCOUNT = 0.3
  THIRD_DISCOUNT = 0.5

  def initialize(params, cars)
    @id = params['id']
    @car = cars[params['car_id']]
    @start_date = Date.parse params['start_date']
    @end_date = Date.parse params['end_date']
    @distance = params['distance']
    @commission = Commission.new(self)
  end

  def days
    1 + (@end_date - @start_date).to_i
  end

  def price
    rental_days = days

    price_per_day = @car.price_per_day - (@car.price_per_day * get_discount(rental_days))

    amount = rental_days * price_per_day + (@distance * @car.price_per_km)
    amount.to_i
  end

  def actions
    [
        {
            "who": "driver",
            "type": "debit",
            amount: price,
        },
        {
            "who": "owner",
            "type": "credit",
            amount: price - @commission.total,
        }
    ].concat @commission.data
  end

  def data
    {
        id: @id,
        actions: actions,
    }
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