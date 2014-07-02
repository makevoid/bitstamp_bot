module Stampable

  def connection_ok
    balance_get
    @test_call = @@balance
    @test_call["error"].nil?
  end

  def connection_error
    @test_call["error"]
  end

  attr_accessor :reserves



  @@balance = nil
  @@ask = nil
  @@orders_open = nil

  THROTTLE_TIME = 10

  def balance_get
    if !@@balance || @@balance[:time] < (Time.now - THROTTLE_TIME)
      @@balance = { balance: Bitstamp.balance, time: Time.now }
    end
    @@balance
  end

  def ask_get
    if !@@ask || @@ask[:time] < (Time.now - THROTTLE_TIME)
      @@ask = { ask: Bitstamp.ticker.ask.to_f, time: Time.now }
    end
    @@ask
  end

  def reserves_get
    balance_get
    balance = @@balance[:balance]
    buy = balance["usd_available"].to_f / ask
    @reserves = {
      buy:      buy,
      sell:     balance["btc_available"].to_f,
      buy_usd:  balance["usd_available"].to_f,
    }
  end

  def bid
    @bid ||= Bitstamp.ticker.bid.to_f # bid do sell
  end

  def ask
    ask_get[:ask] # ask to buy
  end

  def value
    # note to myself: use this kind of code only in controllers, not in models/libs
    #@value ||= Bitstamp.ticker.last.to_f
    Bitstamp.ticker.last.to_f
  end

  # orders & transactions (open and closed orders)

  def orders_open
    orders = Bitstamp.orders.all
    orders.sort_by{ |order| order.price }.reverse
  end

  def orders_open_cached
    if !@@orders_open || @@orders_open[:time] < (Time.now - THROTTLE_TIME)
      @@orders_open = { open: orders_open, time: Time.now }
    end
    @@orders_open
  end

  def orders_closed
    # note: this is ok because it has to be kept all the time
    @@orders_closed ||= Bitstamp.user_transactions.all(limit: 1000000)
  end

end