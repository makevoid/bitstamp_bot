

# format: key|secret
secrets = File.read( File.expand_path "~/.bitstamp" ).strip
user, key, secret = secrets.split "|"

BITSTAMP_USERNAME   = user
BITSTAMP_API_KEY    = key
BITSTAMP_API_SECRET = secret

class BitstampApi

  require 'bitstamp'

  BITSTAMP_FEE = 0.004 # 0.4% fee (if you are starting a new bitstamp account set it to 0.5 then decrease it)

  def initialize
    config
    true
  end

  def config
    Bitstamp.setup do |config|
      config.client_id  = BITSTAMP_USERNAME
      config.key        = BITSTAMP_API_KEY
      config.secret     = BITSTAMP_API_SECRET
    end
  end

  def orders
    o = Orders.new
    o.get
    o
  end

  require_relative "mixins/stampable"
  include Stampable

  class Orders
    attr_reader :open, :closed

    def initialize
      @open   = []
      @closed = []
    end

    def get
      @open   = []
      @closed = []
    end
  end

end