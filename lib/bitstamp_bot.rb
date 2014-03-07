require 'bitstamp'


# format: key|secret
secrets = File.read( File.expand_path "~/.bitstamp" ).strip
user, key, secret = secrets.split "|"

BITSTAMP_USERNAME   = user
BITSTAMP_API_KEY    = key
BITSTAMP_API_SECRET = secret

class BitstampBot

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

  BITSTAMP_FEE = 2 # percent

  BEST_MIN = 656
  GOOD_MIN = 658
  GOOD_MAX = 666
  BEST_MAX = 672

  FIXED_AMOUNT = 5 # usd

  WAIT_TIME = 5 # seconds (todo: consider splitting buy and sell wait times)


  def run

    # while true
    5.times do
      get_reserves

      buy_reserve  = 0.1 # btc
      sell_reserve = 67  # usd

      next unless @wait < 0
      if    buy_reserve  > 0 && amount = buying_is_good
        buy  amount
      elsif sell_reserve > 0 && amount = selling_is_good
        sell amount
      end

      sleep 1 # normal wait
      @wait -= 1
    end
  end

  def get_reserves

  end

  def current_value
    Bitstamp.ticker.last
  end

  def buying_is_good
    current_value < GOOD_MIN
  end

  def selling_is_good
    current_value > GOOD_MAX
  end

  def buy(suggested)
    amount = FIXED_AMOUNT
    puts "buying #{amount}"
    @wait = WAIT_TIME
  end

  def sell(suggested)
    amount = FIXED_AMOUNT
    puts "selling #{amount}"
    @wait = WAIT_TIME
  end

  def ticker
    hash = {}
    methods = %w(last high low bid ask volume)
    ticker = Bitstamp.ticker
    for method in methods
      hash[method.to_sym] = ticker.send(method).to_f
    end
    hash[:volume] = hash[:volume].to_f.round
    hash
  end

end

#


btb = BitstampBot.new
#p btb.ticker
#p btb.run

p Bitstamp.orders.all.size

Bitstamp.orders.buy amount: 0.01, price: 901

p Bitstamp.orders.all.size
#p Bitstamp.user_transactions.all

# time ruby lib/bitstamp_bot.rb