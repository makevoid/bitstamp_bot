# c_data =
#   labels: labels,  bezierCurve: false,
#   animationSteps: 1,
#   pointDot: false,
#   datasets: [
#     {
#       fillColor : "rgba(220,220,220,0.5)",
#       strokeColor : "rgba(220,220,220,1)",
#       pointColor : "rgba(220,220,220,1)",
#       pointStrokeColor : "#fff",
#       data : data,
#     },
#     {
#       fillColor : "rgba(0,220,220,0.5)",
#       strokeColor : "rgba(0,220,220,1)",
#       pointColor : "rgba(0,220,220,1)",
#       pointStrokeColor : "#fff",
#       data : data_ma9,
#     },
#     {
#       fillColor : "rgba(220,220,0,0.5)",
#       strokeColor : "rgba(220,220,0,1)",
#       pointColor : "rgba(220,220,0,1)",
#       pointStrokeColor : "#fff",
#       data : data_ma19,
#     },
#   ]

main = ->

  # dygraph.js
  g = new Dygraph(
    document.querySelector(".graph"),
    "values.csv",
    {
      #rollPeriod: 1, # real
      rollPeriod: 3,  # smoothed a bit
      #rollPeriod: 7,
      showRoller: true,
    }
  )

  # chart.js
  #
  # ctx = document.querySelector("canvas").getContext "2d"
  # chart  = new Chart(ctx).Line c_data       #, options

  # setTimeout ->
  #   window.location = "/graph"
  # , 20000

window.onload = main