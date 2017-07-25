var divClone;
var endingDigits;
var numberOfPricePoints;
var percentIncrease;
var percentDecrease;
var newValue = [];

$(document).ready(function(){
    divClone = $("#price-test-table").clone();
  });
  
$(function () {
  $("#price-test-form").keyup(function() {
    getFormData();
    $.each($('td.variant-price'), function(index,cell) {
      var Value = round(parseFloat($(cell).text()) * (1 + percentIncrease/100),2); // ensure this is a positive number on the input itself
      //var newValue = round(parseFloat($(cell).text()) * (1 - percentDecrease/100),2); // ensure this is a positive number on the input itself
      Value = Math.floor(Value)+endingDigits;
      newValue[index] =  Value;
      // $(cell).text(newValue);
    });
    // $.each($('td.price-basement'), function(index,cell) {
    //   var newValue = round(parseFloat($(cell).text()) * (1 - percentDecrease/100),2); // ensure this is a positive number on the input itself
    //   newValue = Math.floor(newValue)+endingDigits;
    //   $(cell).text(newValue);
    // });
            
    $("#price-test-table > thead  > tr").last().append("<th>" + 'Diff' + "</th>");
    $("#price-test-table > tbody  > tr").each(function(index, cell) {
      // var test = round(parseFloat($('td.price-ceiling')[index].innerText)-
      //           parseFloat($('td.price-basement')[index].innerText),2);
      if (validPricePoints(newValue[index],2)) {
        $(cell).append("<td>" + newValue[index]  + "</td>");
      }
      else {
        $(cell).append("<td>" + "NOPE"  + "</td>");
      }
    });
    
  });
});

function validPricePoints(value, number) {
  if (value/number >= 1) return true;
  return false;
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

