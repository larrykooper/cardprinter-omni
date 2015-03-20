// All this logic will automatically be available in application.js.

var mydata = {};

var getdataSuccess = function(data, status) {
    var arrayLength, i, key, myobject, snippet, one_row;
    // data is an array of objects
    // The following displays the data on screen
    console.log('Message 8: getting data was successful');
    $('#spinner').hide();
    mydata = data;
    arrayLength = data.length;
    for (i = 0; i < arrayLength; i++) {
        one_row = '<p>';
        myobject = data[i];
        for (key in myobject) {
            if (myobject.hasOwnProperty(key)) {
                // This adds each field
                snippet = '<span>'+ key + ' ' + myobject[key] + '</span>';
                one_row = one_row + snippet;
            }
        }
        one_row = one_row + '</p>'
        $('.data').append(one_row);
    }

};

var printCardsSuccess = function(data, status) {
    console.log('Message 13: printing cards was successful');
};

var ajaxError = function(jqXHR, status, error) {
    console.log('Message 14: There has been an Ajax error.');
    console.log('Message 15: Status and error follow.');
	console.log(status);
	console.log(error);
};

$(document).ready(function() {
    $(".get-data").click(function() {
        $.ajax({
            url: '/spreadsheet/getdata',
            success: getdataSuccess,
            error: ajaxError,
            dataType: "json",
            beforeSend: function () {
                $('#spinner').show();
            },
        });
    }); // end - click

    $(".done-picking").click(function() {
        $.ajax({
            url: '/printcards',
            method: "POST",
            data: {data: mydata},
            success: printCardsSuccess,
            error: ajaxError,
            dataType: "json"
        });
    });

});  // end- document.ready
