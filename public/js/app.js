var main;

main = function() {
  var g;
  g = new Dygraph(document.querySelector(".graph"), "values.csv", {
    rollPeriod: 3,
    showRoller: true
  });
  return setTimeout(function() {
    return window.location = "/graph";
  }, 20000);
};

window.onload = main;
