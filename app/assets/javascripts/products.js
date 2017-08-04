var originalTableData, endingDigits;

$(function () {
  storeOriginalData();
  toggleDecreaseInput();
    
  $("div#price-test-form").change(function() {
    setOriginalFormData();
    updateEndingDigits();
    toggleDecreaseInput();
    var pricePointArray = calculatePriceMatrix();
    setPricePointHeaders(pricePointArray);
    setPricePointTable(pricePointArray);
  });
  
  // $('#new_price_test').submit(function(e){
  //   e.preventDefault();
  //   $.ajax({
  //     type: "POST",
  //     url: '/price_tests',
  //     data: $(this).serialize(),
  //     dataType: 'json'
  //   })
  //   .done(function() {
  //     alert( "Success!" );
  //   });
  // });
});

function calculatePriceMatrix() {
  var priceArray = [];
  var pricePoints = parseFloat($("select#price_test_price_points").val());
  var percentDecrease = $("input#price_test_percent_decrease").val();
  var percentIncrease = $("input#price_test_percent_increase").val();

  $.each($('td.variant-price'), function(index,cell) {
    var originalPrice = parseFloat($(cell).text());
    var upperValue = Math.floor(originalPrice * (1 + percentIncrease / 100)) + endingDigits; // ensure this is a positive number on the input itself
    var lowerValue = Math.floor(originalPrice * (1 - percentDecrease/100)) + endingDigits; // ensure this is a positive number on the input itself
    priceArray.push(stepPricePoints(upperValue, lowerValue, pricePoints));
  });
  return priceArray;
}

function validPricePoints(value, number) {
  return (value/number >= 1);
}

function storeOriginalData() {
  originalTableData = $("#price-test-table").clone();
}

// TODO ensure violation of price seperation rule above does not accur in below func
// takes difference between upper and lower bounds and finds equidistant price points between the two
// ex. upper 150, lower 50, 5 p.p., (150-50)/(5-1)= 25.  50,(50+25),(50+25+25), etc
function stepPricePoints(upper, lower, number_of_test_points) {
  number_of_test_points -= 1;
  var pricePoints = []; 
  if(number_of_test_points > 0) {
    pricePoints.push(lower);
  }
  var step = (upper - lower)/number_of_test_points;
  for(var i=1; i<number_of_test_points; i++){
    pricePoints.push(Math.floor(pricePoints[i-1] + step) + endingDigits);
  } 
  pricePoints.push(upper);
  return pricePoints;
}

function setOriginalFormData() {
  $("#price-test-table").html(originalTableData.html());
}

function updateEndingDigits() {
  endingDigits = parseFloat($("select#price_test_ending_digits").val());
}

function setPricePointHeaders(priceArray) {
  $.each(priceArray[0], function(index,value){
    $("#price-test-table > thead  > tr").last().append("<th>" + 'Price ' + index + "</th>");
;
  });
}

function setPricePointTable(priceArray) {
  $("#price-test-table > tbody  > tr").each(function(row, cell) {
    $.each(priceArray[row], function(col,value){
      $(cell).append("<td class=row-" + row + "-col-" + col + 
                     "><input class='manual_price' type=number value=" + priceArray[row][col]
                     + ">" + "</input></td>");
    });
  });
}

function toggleDecreaseInput() {
  var pricePoints = parseFloat($("select#price_test_price_points").val());
  if (pricePoints == 1) {
    $("input#price_test_percent_decrease").val(0);
    $("input#price_test_percent_decrease").attr('disabled','disabled');
  } else {
    $("input#price_test_percent_decrease").removeAttr('disabled');
  }
};

