require 'json'
require 'date'

def level_three(file)

  #Open & parse file
  f = File.read(file)
  data = JSON.parse(f)
  #separate data in two arrays to shorten syntax
  workers = data["workers"]
  shifts = data["shifts"]

  #Addition of a method to convert date from data input into weekday format
  def weekday(date_string)
    Date.parse(date_string).strftime("%A")
  end

  #price per status
  price_per_status = {
    "medic" => 270,
    "interne" => 126
  }

  #define & populate initial output fields
  output = {
    "workers" => []
  }

  workers.each do |worker|
    worker_info = {}
    worker_info["id"] = worker["id"]
    worker_info["price"] = 0
    output["workers"] << worker_info
  end

  #loop over shifts to update values in output
  shifts.each do |shift|
    #Check if user_id exists in output["workers"] list of hashes
    if output["workers"].any? {|h| h["id"] == shift["user_id"]}
      idx = shift["user_id"] - 1
      day = weekday(shift["start_date"])
      if day == "Saturday" || day == "Sunday"
        price_to_add = (price_per_status[workers[idx]["status"]] * 2)
      else
        price_to_add = price_per_status[workers[idx]["status"]]
      end
      output["workers"][idx]["price"] += price_to_add
    end
  end

  # Write output in a JSON file
  File.open("output.json","w") do |f|
    f.write(output.to_json)
  end

end

level_three("data.json")
