require 'bitstamp'

path = File.expand_path "../../", __FILE__
PATH = path

# format: key|secret
secrets = File.read( File.expand_path "~/.bitstamp" ).strip
user, key, secret = secrets.split "|"

BITSTAMP_USERNAME   = user
BITSTAMP_API_KEY    = key
BITSTAMP_API_SECRET = secret


class PriceGetFail < StandardError
end

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

  ORDER_IDS = []

  BITSTAMP_FEE = 0.005 # 5% fee
  def apply_fee(value)
    value * (1 - BITSTAMP_FEE)
  end


  # BEST_MIN = 656
  # GOOD_MIN = 658
  # GOOD_MAX = 666
  # BEST_MAX = 672

  GOOD_MIN = 610
  GOOD_MAX = 620

  # FIXED_AMOUNT = 0.01  # btc (= 5 usd, production)
  FIXED_AMOUNT = 0.003   # btc (= 1 usd, testing   )

  WAIT_TIME = 5 # seconds (todo: consider splitting buy and sell wait times)

  # BOT_START_TIME = 1 # minutes
  # consider all requests made before non-bot and cancel them
  # dt = Time.now - DateTime.parse("datetime").to_time

  # EMA1_GT_EMA2 = ?

  def backup_history
    backup = json_read "closing"
    json_write "closing_backup", backup
  end

  def delete_history
    backup_history
    json_write "closing", []
  end

  def closing_price_get
    value

    rescue Curl::Err::ConnectionFailedError
    puts "failed to get price"
    PriceGetFail
  end

  require_relative "mixins/utils"
  include Utils

  def closing_price_write(price)
    prices = json_read "closing"
    prices << price
    puts "got current price: #{price}"
    json_write "closing", prices
  end

  def run

    delete_history

    while true
      price = closing_price_get
      unless price == PriceGetFail
        closing_price_write price
        # notify ui (sse?)
      end

      sleep 20
      #sleep 60
    end

    exit

    @wait = 0
    # while true
    1.times do
      reserves = reserves_get


      # "user" input here
      execute_current_strategy


      sleep 1 # normal wait
      @wait -= 1
    end

    cancel_transactions

  end

  def execute_current_strategy

  end

  require_relative "mixins/stampable"
  include Stampable

  def buying_is_good
    value < GOOD_MIN
  end

  def selling_is_good
    value > GOOD_MAX
  end

  def buy(suggested)
    amount = FIXED_AMOUNT
    puts "buying #{amount}"
    order = Bitstamp.orders.buy amount: amount, price:
    ORDER_IDS << order.id
    @wait = WAIT_TIME
  end

  def sell(suggested)
    amount = FIXED_AMOUNT
    puts "selling #{amount}"
    order = Bitstamp.orders.sell amount: amount, price: 500
    ORDER_IDS << order.id
    @wait = WAIT_TIME
  end

  def cancel_transactions
    for order_id in ORDER_IDS
      order = Bitstamp::Order.new id: order_id
      order.cancel!
    end
  end

  private

  def all_orders
    Bitstamp.orders.all
  end

  def cancel_transactions_fixed
    for order in all_orders
      order.cancel! if order.amount.to_f == FIXED_AMOUNT
    end
  end


  # utils

  public

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
btb.run

#btb.cancel_transactions_fixed


#p Bitstamp.orders.all





#p Bitstamp.orders.all.size
#p Bitstamp.user_transactions.all

# time ruby lib/bitstamp_bot.rb