require 'json'
require './app/lib/dataHandler.rb'
require './app/model/car.rb'
require './app/model/rental.rb'
require './app/model/commission.rb'

# starting point
def main
  inputs = DataHandler::json_to_hash

  cars = {}
  inputs['cars'].each do |car|
    cars[car['id']] = Car.new car
  end

  rentals = {}
  inputs['rentals'].each do |rental|
    rentals[rental['id']] = Rental.new rental, cars, inputs['options']
  end

  DataHandler::generate_rental_prices rentals
end

main