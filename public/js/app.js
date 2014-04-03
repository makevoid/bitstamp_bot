var data, main;

data = {
  labels: data,
  datasets: [
    {
      fillColor: "rgba(220,220,220,0.5)",
      strokeColor: "rgba(220,220,220,1)",
      pointColor: "rgba(220,220,220,1)",
      pointStrokeColor: "#fff",
      data: data
    }
  ]
};

main = function() {
  var chart, ctx;
  ctx = document.querySelector("canvas").getContext("2d");
  chart = new Chart(ctx).Line(data);
  return setTimeout(function() {
    return window.location = "/";
  }, 20000);
};

window.onload = main;
