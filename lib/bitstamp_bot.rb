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

  ORDER_IDS = []

  BITSTAMP_FEE = 0.005 # 5% fee
  def apply_fee(value)
    value * (1 - BITSTAMP_FEE)
  end


  # BEST_MIN = 656
  # GOOD_MIN = 658
  # GOOD_MAX = 666
  # BEST_MAX = 672

  GOOD_MIN = 625
  GOOD_MAX = 635

  # FIXED_AMOUNT = 0.01  # btc (= 5 usd, production)
  FIXED_AMOUNT = 0.003   # btc (= 1 usd, testing   )

  WAIT_TIME = 5 # seconds (todo: consider splitting buy and sell wait times)

  # BOT_START_TIME = 1 # minutes
  # consider all requests made before non-bot and cancel them
  # dt = Time.now - DateTime.parse("datetime").to_time


  def run
    @wait = 0
    # while true
    puts "ticker:", Bitstamp.ticker.inspect

    1000.times do
      reserves = get_reserves
      # TODO: don't fetch reserves everytime

      # exit

      # buy_reserve  = 0.1 # btc - btc_available
      # sell_reserve = 67  # usd - usd_available

      next unless @wait <= 0
      p buying_is_good
      exit
      if    reserves[:buy]  > FIXED_AMOUNT# && buying_is_good
        buy
      elsif reserves[:sell] > FIXED_AMOUNT# && selling_is_good
        sell
      end

      sleep 3 # normal wait
      @wait -= 1
    end

    cancel_transactions

  end

  def get_reserves
    balance = Bitstamp.balance
    buy = balance["usd_available"].to_f / value
    {
      buy:      buy,
      sell:     balance["btc_available"].to_f,
      buy_usd:  balance["usd_available"].to_f,
    }
  end

  def bid
    Bitstamp.ticker.bid.to_f # bid do sell
  end

  def ask
    Bitstamp.ticker.ask.to_f # ask to buy
  end

  def value
    Bitstamp.ticker.last.to_f # TODO: get more historic/stable value also
  end

  def buying_is_good
    value < GOOD_MIN
  end

  def selling_is_good
    value > GOOD_MAX
  end

  def price_buy
    value - 2
  end

  def price_sell
    value + 2
  end

  def buy
    amount = FIXED_AMOUNT
    puts "buying #{amount} at #{price_buy}"
    order = Bitstamp.orders.buy amount: amount, price: price_buy
    ORDER_IDS << order.id
    @wait = WAIT_TIME
  end

  def sell
    amount = FIXED_AMOUNT
    puts "selling #{amount} at #{price_sell}"
    order = Bitstamp.orders.sell amount: amount, price: price_sell
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