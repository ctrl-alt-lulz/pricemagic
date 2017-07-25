var divClone;
var endingDigits;
var numberOfPricePoints;

$(document).ready(function(){
    divClone = $("#price-test-table").clone();
  });
  
$(function () {
  $("#price-test-form").keyup(function() {
    
    endingDigits = parseFloat($("select#price_test_ending_digits").val());
    numberOfPricePoints = parseFloat($("select#price_test").val());
    
    $("#price-test-table").html(divClone.html());
    var percentIncrease = $("input#price_test_percent_increase").val();
    var percentDecrease = $("input#price_test_percent_decrease").val();
    $.each($('td.price-ceiling'), function(index,cell) {
      var newValue = round(parseFloat($(cell).text()) * (1 + percentIncrease/100),2); // ensure this is a positive number on the input itself
      newValue = Math.floor(newValue)+endingDigits;
      $(cell).text(newValue);
    });
    $.each($('td.price-basement'), function(index,cell) {
      var newValue = round(parseFloat($(cell).text()) * (1 - percentDecrease/100),2); // ensure this is a positive number on the input itself
      newValue = Math.floor(newValue)+endingDigits;
      $(cell).text(newValue);
    });
    
    $("#price-test-table > thead  > tr").last().append("<th>" + 'Diff' + "</th>");
    $("#price-test-table > tbody  > tr").each(function(index, cell) {
      var row = $(cell);
      var test = round(parseFloat($('td.price-ceiling')[index].innerText)-
                 parseFloat($('td.price-basement')[index].innerText),2);
      $(cell).append("<td>" + test + "</td>");
    });
    
  });
});

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

