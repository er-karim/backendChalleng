# This class represents the data handler
class DataHandler
  INPUT_FILE_PATH = "./app/data/input.json"
  OUTPUT_FILE_PATH = "./app/data/output.json"

  # Generate hash from json
  def self.json_to_hash
    begin
      file = File.read INPUT_FILE_PATH
      JSON.parse(file)
    rescue JSON::ParserError
      print INPUT_FILE_PATH+" this file doaesn't contain json data"
    rescue Errno::ENOENT
      print "No such file : "+INPUT_FILE_PATH+"\n"
    end
  end

  # Generate output.json from rentals
  # Params:
  # +rentals+:: hash of rentals
  def self.generate_rental_prices rentals
    rental_prices = {rentals: []}
    rentals.each do |id, rental|
      rental_prices[:rentals] << rental.data
    end

    begin
      json_output = File.open(File.expand_path(OUTPUT_FILE_PATH), 'w')
      json_output << JSON.generate(rental_prices)
      json_output.close
    rescue Errno::ENOENT
      print "No such file : "+OUTPUT_FILE_PATH+"\n"
    end
  end
end