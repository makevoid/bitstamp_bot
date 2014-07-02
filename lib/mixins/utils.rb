module Utils

  def json_path(name)
    "#{PATH}/db/#{name}.json"
  end

  def json_create(name)
    json_write name, {} unless File.exist?(json_path name)
  end

  def json_read(name)
    data = File.read json_path(name)
    JSON.parse data
  end

  def json_write(name, data)
    File.open json_path(name), "w" do |f|
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