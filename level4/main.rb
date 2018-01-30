require 'json'
require 'date'

def level_four(file)

  #Open & parse file
  f = File.read(file)
  data = JSON.parse(f)
  #separate data in two arrays of hashes to shorten syntax
  workers = data["workers"]
  shifts = data["shifts"]

  #price per status with interim added
  price_per_status = {
    "medic" => 270,
    "interne" => 126,
    "interim" => 480
  }

  #Method to convert date from data input into weekday format
  def weekday(date_string)
    Date.parse(date_string).strftime("%A")
  end

  #define & populate initial output fields
  output = {
    "workers" => [],
    "commission" => {
      "pdg_fee" => 0,
      "interim_shifts" => 0
    }
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
      # idx = shift["user_id"] - 1
      worker_selected = workers.select {|worker| worker["id"] == shift["user_id"] }.first
      #if worker status on this shift is interim add one to the count
      worker_selected["status"] == "interim" ? output["commission"]["interim_shifts"] += 1 : nil
      day = weekday(shift["start_date"])
      if day == "Saturday" || day == "Sunday"
        price_to_add = (price_per_status[worker_selected["status"]] * 2)
      else
        price_to_add = price_per_status[worker_selected["status"]]
      end
      output["workers"][worker_selected["id"]-1]["price"] += price_to_add
    end
  end

  #calculate total fees
  shifts_margin = 0
  output["workers"].each do |worker|
    shifts_margin += worker["price"] * 0.05
  end
  output["commission"]["pdg_fee"] =  shifts_margin + output["commission"]["interim_shifts"] * 80

  # Write output in a JSON file
  File.open("output_four.json","w") do |f|
    f.write(output.to_json)
  end

end

level_four("data.json")
