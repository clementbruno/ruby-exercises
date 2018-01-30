require 'json'

def level_one(file)

  #Open & parse file
  f = File.read(file)
  data = JSON.parse(f)
  #separate data in two arrays to shorten syntax
  workers = data["workers"]
  shifts = data["shifts"]


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
    idx = shift["user_id"] - 1
    output["workers"][idx]["price"] += workers[idx]["price_per_shift"]
  end


  #Write output in a JSON file
  File.open("output.json","w") do |f|
    f.write(output.to_json)
  end

end

level_one("data.json")



