module Stampable

  def connection_ok
    balance_get
    @test_call = @@balance
    raise @@balance.inspect
    @test_call["error"].nil?
  end

  def connection_error
    @test_call["error"]
  end

  attr_accessor :reserves



  @@balance = nil
  @@ask = nil

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
    @value ||= Bitstamp.ticker.last.to_f
  end

end