path = File.expand_path "../../", __FILE__
PATH = path

require 'json'
require "moving_average"

require "#{PATH}/lib/mixins/utils"
include Utils

require "#{path}/lib/vendor/mhash"
require "#{path}/lib/bitstamp_api"