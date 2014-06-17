var main;

main = function() {
  var g;
  return g = new Dygraph(document.querySelector(".graph"), "values.csv", {
    rollPeriod: 3,
    showRoller: true
  });
};

window.onload = main;
