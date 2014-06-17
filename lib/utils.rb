module Utils

  def json_read(name)
    data = File.read "#{PATH}/db/#{name}.json"
    JSON.parse data
  end

  def json_write(name, data)
    File.open "#{PATH}/db/#{name}.json", "w" do |f|
      f.write data.to_json
    end
  end

end

# monkeypatches

class Array
  def map_round
    map{ |elem| elem.round(3) }
  end
end