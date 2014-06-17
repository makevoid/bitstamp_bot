# p Bitstamp.ticker
# exit

# buy_reserve  = 0.1 # btc - btc_available
# sell_reserve = 67  # usd - usd_available

next unless @wait <= 0
if    reserves[:buy]  > FIXED_AMOUNT && amount = buying_is_good
  buy  amount
elsif reserves[:sell] > FIXED_AMOUNT && amount = selling_is_good
  sell amount
end


############################

history = []#...

# tempo stretto (10m o meno)
ema_low  = ema(21)
ema_high = ema(29)

# cross returns :raising or :falling trend values
trend = cross ema_low(history), ema_high(history) 
if trend == :raising
  buy  0.25 # 1/4
else
  sell 0.25 # 1/4
end

############################

ema
