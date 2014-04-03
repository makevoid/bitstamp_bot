


data =
  #labels : ["January","February","March","April","May","June","July"],
  labels: data,
  datasets : [
    {
      fillColor : "rgba(220,220,220,0.5)",
      strokeColor : "rgba(220,220,220,1)",
      pointColor : "rgba(220,220,220,1)",
      pointStrokeColor : "#fff",
      data : data
    }
  ]


main = ->
  ctx = document.querySelector("canvas").getContext "2d"
  chart = new Chart(ctx).Line data#, options

  setTimeout ->
    window.location = "/"
  , 20000

window.onload = main