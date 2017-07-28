var divClone;
var endingDigits; // being used globally check if ok, or should list explicit in stepfunction
var numberOfPricePoints;
var percentIncrease;
var percentDecrease;
var upperValueIndex = [];
var lowerValueIndex = [];
var pricePointArray = [];
var manual;
$("input#manual_entry").is(':checked');
$(document).ready(function(){
    divClone = $("#price-test-table").clone();
    numberOfPricePoints = parseFloat($("select#price_test").val());
    toggleFormData(numberOfPricePoints);
});
  
$(function () {
  $("#price-test-form").change(function() {
    pricePointArray = [];
    getFormData();
    toggleFormData(numberOfPricePoints);
    $.each($('td.variant-price'), function(index,cell) {
      var upperValue = round(parseFloat($(cell).text()) * (1 + percentIncrease/100),2); // ensure this is a positive number on the input itself
      var lowerValue = round(parseFloat($(cell).text()) * (1 - percentDecrease/100),2); // ensure this is a positive number on the input itself
      upperValue = Math.floor(upperValue)+endingDigits;
      upperValueIndex[index] =  upperValue;
      if (numberOfPricePoints > 1) {
        lowerValue = Math.floor(lowerValue)+endingDigits;
        lowerValueIndex[index] =  lowerValue;
        //var diff = upperValue - lowerValue;
        pricePointArray.push(stepPricePoints(upperValue, lowerValue, numberOfPricePoints));}
    });
    if (numberOfPricePoints < 2){
    $("#price-test-table > thead  > tr").last().append("<th>" + 'Price' + "</th>");
    $("#price-test-table > tbody  > tr").each(function(index, cell) {
        $(cell).append("<td>" + upperValueIndex[index]  + "</td>");
    });}
    else {
      $.each(pricePointArray[0], function(index,value){
        $("#price-test-table > thead  > tr").last().append("<th>" + 'Price ' + index + "</th>");
      });
      $("#price-test-table > tbody  > tr").each(function(index, cell) {
        $.each(pricePointArray[index], function(index1,value){
          $(cell).append("<td>" + "<input type='number'>" + manual + pricePointArray[index][index1]  + "</input>" + "</td>");
          //$(cell).append("<td>" + "<input type='number'>" + "blah" + "</input>" + "</td>").addClass("tableRow");
          $(cell).children('td').each(function(indexer) {
            $(this).addClass(index + '-class-' + indexer);});
          $(cell).children('input').each(function(indexer) {
            $(this).addClass(index + '-class-' + indexer);});
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
  manual = $("input#manual_entry").is(':checked');
  endingDigits = parseFloat($("select#price_test_ending_digits").val());
  numberOfPricePoints = parseFloat($("select#price_test").val());
  percentIncrease = $("input#price_test_percent_increase").val();
  percentDecrease = $("input#price_test_percent_decrease").val();
};

// TODO validate other input is cleared when toggled off
function toggleFormData(numberOfPricePoints) {
  (numberOfPricePoints == 1) ? $("div#single_price_point").hide() : $("div#single_price_point").show()
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

