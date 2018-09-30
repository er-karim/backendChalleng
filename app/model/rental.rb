require 'date'

class Rental

  attr_accessor :id, :car, :start_date, :end_date, :distance, :commission, :features

  FIRST_DISCOUNT = 0.1
  SECOND_DISCOUNT = 0.3
  THIRD_DISCOUNT = 0.5

  ACTORS = ['driver', 'owner', 'insurance', 'assistance', 'drivy']
  FEATURE_TYPES = {
      'gps' => 5,
      'baby_seat' => 2,
      'additional_insurance' => 10
  }

  # Create new rental instance
  # Params:
  # +params+:: hash row in array of rentals from input.json
  # +cars+:: hash of cars generated from input.json
  # +additional_features+:: array of features from input.json
  def initialize(params, cars, additional_features)
    @id = params['id']
    @car = cars[params['car_id']]
    @start_date = Date.parse params['start_date']
    @end_date = Date.parse params['end_date']
    @distance = params['distance']
    @commission = Commission.new(self)
    @features = []
    additional_features.each do |feature|
      if feature['rental_id'] == @id
        @features << feature['type']
      end
    end
  end

  # Get the rental price
  def price
    price_per_day = @car.price_per_day - (@car.price_per_day * get_discount)

    amount = days * price_per_day + (@distance * @car.price_per_km)
    amount.to_i
  end

  # Get the rental days
  def days
    1 + (@end_date - @start_date).to_i
  end

  # Generate hash to put in output.json
  def data
    {
        id: @id,
        options: @features,
        actions: actions,
    }
  end

  private

  # Generate actions for data method
  def actions
    result = []

    ACTORS.each do |actor|
      case actor
        when 'driver'
          amount = price
          if @features.include? "gps"
            amount += days * FEATURE_TYPES['gps']
          end
          if @features.include? "baby_seat"
            amount += days * FEATURE_TYPES['baby_seat']
          end
          if @features.include? "additional_insurance"
            amount += days * FEATURE_TYPES['additional_insurance']
          end

        when 'owner'
          amount = price - @commission.total
          if @features.include? "gps"
            amount += days * FEATURE_TYPES['gps']
          end
          if @features.include? "baby_seat"
            amount += days * FEATURE_TYPES['baby_seat']
          end

        when 'insurance'
          amount = @commission.insurance_fee.to_i

        when 'assistance'
          amount = @commission.assistance_fee.to_i

        else # "drivy"
          amount = @commission.drivy_fee.to_i
          if @features.include? "additional_insurance"
            amount += days * FEATURE_TYPES['additional_insurance']
          end

      end

      result << {
          who: actor,
          type: (actor == "driver") ? "debit" : "credit",
          amount: amount.to_i
      }
    end
    result
  end

  # Get the correct discount according to the rental days
  def get_discount
    case days
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