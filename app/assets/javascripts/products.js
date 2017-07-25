var divClone;
var endingDigits; // being used globally check if ok, or should list explicit in stepfunction
var numberOfPricePoints;
var percentIncrease;
var percentDecrease;
var upperValueIndex = [];
var lowerValueIndex = [];
var pricePointArray = [];

$(document).ready(function(){
    divClone = $("#price-test-table").clone();
  });
  
$(function () {
  $("#price-test-form").keyup(function() {
    pricePointArray = [];
    getFormData();
    $.each($('td.variant-price'), function(index,cell) {
      var upperValue = round(parseFloat($(cell).text()) * (1 + percentIncrease/100),2); // ensure this is a positive number on the input itself
      var lowerValue = round(parseFloat($(cell).text()) * (1 - percentDecrease/100),2); // ensure this is a positive number on the input itself
      upperValue = Math.floor(upperValue)+endingDigits;
      upperValueIndex[index] =  upperValue;
      if (numberOfPricePoints > 1) {
      lowerValue = Math.floor(lowerValue)+endingDigits;
      lowerValueIndex[index] =  lowerValue;}
      pricePointArray.push(stepPricePoints(upperValue, lowerValue, numberOfPricePoints));
      console.log(pricePointArray);
    });
    if (numberOfPricePoints < 2){
    $("#price-test-table > thead  > tr").last().append("<th>" + 'Diff' + "</th>");
    $("#price-test-table > tbody  > tr").each(function(index, cell) {
        $(cell).append("<td>" + upperValueIndex[index]  + "</td>");
    });}
    else {
      $.each(pricePointArray[0], function(index,value){
        console.log(index);
        console.log(value);
        console.log(pricePointArray[0]);
        $("#price-test-table > thead  > tr").last().append("<th>" + 'Diff' + index + "</th>");
      });
      
      $("#price-test-table > tbody  > tr").each(function(index, cell) {
        $.each(pricePointArray[index], function(index1,value){
          $(cell).append("<td>" + pricePointArray[index][index1]  + "</td>");
        });
    });}
    
  });
});

function validPricePoints(value, number) {
  if (value/number >= 1) return true;
  return false;
}

// TODO ensure violation of price seperation rule above does not accur in below func
// ask patrick, does using same var name endingDigits make any difference? any global stuff matter?
function stepPricePoints(upper, lower, number_of_test_points) {
  number_of_test_points -= 1;
  var pricePoints = [lower];
  var step = (upper - lower)/number_of_test_points;
  for(var i=1; i<number_of_test_points; i++){
    pricePoints.push(Math.floor(pricePoints[i-1]+step)+endingDigits);} // global use of endingDigits
  pricePoints.push(upper);
  return pricePoints;
}

function getFormData() {
  $("#price-test-table").html(divClone.html());
  endingDigits = parseFloat($("select#price_test_ending_digits").val());
  numberOfPricePoints = parseFloat($("select#price_test").val());
  percentIncrease = $("input#price_test_percent_increase").val();
  percentDecrease = $("input#price_test_percent_decrease").val();
};

function round(value, exp) {
  if (typeof exp === 'undefined' || +exp === 0)
    return Math.round(value);

  value = +value;
  exp = +exp;

  if (isNaN(value) || !(typeof exp === 'number' && exp % 1 === 0))
    return NaN;

  // Shift
  value = value.toString().split('e');
  value = Math.round(+(value[0] + 'e' + (value[1] ? (+value[1] + exp) : exp)));

  // Shift back
  value = value.toString().split('e');
  return +(value[0] + 'e' + (value[1] ? (+value[1] - exp) : -exp));
}

