require 'json'
require './app/model/car.rb'
require './app/model/rental.rb'
require './app/model/commission.rb'

def main
  inputs = parse_json_to_hash './app/data/input.json'

  cars = {}
  inputs['cars'].each do |car|
    cars[car['id']] = Car.new car
  end

  rentals = {}
  inputs['rentals'].each do |rental|
    rentals[rental['id']] = Rental.new rental, cars
  end

  generate_rental_prices rentals
end

def parse_json_to_hash input_file_path
  begin
    file = File.read input_file_path
    JSON.parse(file)
  rescue JSON::ParserError
    print input_file_path+" this file doaesn't contain json data"
  rescue Errno::ENOENT
    print "No such file : "+input_file_path
  end
end

def generate_rental_prices rentals
  rental_prices = {rentals: []}
  rentals.each do |id, rental|
    rental_prices[:rentals] << rental.data
  end

  json_output = File.open('./app/data/output.json','w')
  json_output << JSON.generate(rental_prices)
  json_output.close
end

main