// All this logic will automatically be available in application.js.

var mydata = {}; // just used to pass (all) the returned data to the card printer; to be deleted

var getdataSuccess = function(data, status) {
    var arrayLength, i, key, myobject, snippet, oneRow, $data, bigstring;
    // data is an array of objects
    // The following displays the data on screen
    console.log('Message 8: getting data was successful');
    $('#spinner').hide();
    mydata = data;
    $data = $('.data');
    bigstring = '';
    bigstring += '<table id="data-area">';
    arrayLength = data.length;
    for (i = 0; i < arrayLength; i++) {
        oneRow = '<tr>';
        myobject = data[i];
        for (key in myobject) {
            if (myobject.hasOwnProperty(key)) {
                // This adds each field
                snippet = '<td>'+ myobject[key] + '</td>';
                oneRow = oneRow + snippet;
            }
        }
        oneRow = oneRow + '</tr>'
        bigstring += oneRow;
    }
    bigstring += '</table>';
    $data.append(bigstring);

};

var printCardsSuccess = function(data, status) {
    console.log('Message 13: printing cards was successful');
};

var ajaxError = function(jqXHR, status, error) {
    $('#spinner').hide();
    console.log('Message 14: There has been an Ajax error.');
    console.log('Message 15: Status, responseText, and error follow.');
	console.log(status);
    console.log(jqXHR.responseText);
	console.log(error);
    $data = $('.data');
    $data.append(jqXHR.responseText);
};

$(document).ready(function() {
    console.log( "You are running jQuery version: " + $.fn.jquery );
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
        console.log('Message 60 - in click handler');
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
