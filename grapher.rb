require 'sinatra'
require 'haml'
require 'json'

path = File.expand_path "../", __FILE__
PATH = path

require "#{PATH}/lib/utils"
include Utils

get "/"  do
  DATA = json_read "closing"

  haml :index
end