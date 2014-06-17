var dyg_mousedown, main;

main = function() {
  var g;
  return g = new Dygraph(document.querySelector(".graph"), "values.csv", {
    rollPeriod: 3,
    showRoller: true,
    drawYGrid: false,
    ylabel: "Price (USD)"
  });
};

dyg_mousedown = function(event, g, context) {};

window.onload = main;
