require 'sinatra'
require 'haml'
require 'json'

path = File.expand_path "../", __FILE__
PATH = path

require "#{PATH}/lib/utils"
include Utils

get "/"  do # grapher
  DATA = json_read "closing"

  haml :index
end

get "/bot/:id" do |id|
  haml :bot
end

get "/backtest" do
  haml :backtest
end

get "/settings" do
  haml :settings
end


# helpers

def read_strategy(strategy)
  File.read "strategies/#{strategy}.rb"
end