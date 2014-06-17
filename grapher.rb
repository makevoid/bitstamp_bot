require 'sinatra'
require 'haml'
require 'json'

path = File.expand_path "../", __FILE__
PATH = path

require "#{PATH}/lib/utils"
include Utils

require "moving_average"

require_relative "lib/bitstamp_api"

class Grapher < Sinatra::Base

  def simple_moving_average(size)
    nums = []
    sum = 0.0
    lambda do |hello|
      nums << hello
      goodbye = nums.length > size ? nums.shift : 0
      sum += hello - goodbye
      sum / nums.length
    end
  end

  get "/"  do
    haml :index
  end

  get "/buy_sell"  do
    haml :buy_sell
  end

  get "/graph"  do
    # DATA = json_read "closing"
    # @data = DATA[-200..-1]
    # @labels = Array.new(@data.size).map{ "" }
    haml :graph
  end

  get "/values.csv" do
    DATA = json_read "closing"
    data = DATA[0..-1]
    # ma9  = simple_moving_average( 9)
    # ma19 = simple_moving_average(19)
    ma9  = simple_moving_average(20)
    ma19 = simple_moving_average(45)
    data_ma9  = data.map{ |d| ma9.call   d }.map_round
    data_ma19 = data.map{ |d| ma19.call  d }.map_round

    csv = "idx,value,ma9,ma19"
    data.each_with_index do |d, idx|
      csv << [idx, d, data_ma9[idx], data_ma19[idx]].join(",") + "\n"
    end
    csv
  end

end