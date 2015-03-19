// All this logic will automatically be available in application.js.

var mydata = {};

var authorizeSuccess = function(data, status) {
    var arrayLength, i, key, myobject, snippet, bigsnippet;
    // data is an array of objects
    // The following displays the data on screen
    console.log('Message 8: authorization was successful');
    mydata = data;
    arrayLength = data.length;
    for (i = 0; i < arrayLength; i++) {
        bigsnippet = '';
        myobject = data[i]
        for (key in myobject) {
            if (myobject.hasOwnProperty(key)) {
                snippet = '<span>'+ key + ' ' + myobject[key] + '</span>';
                bigsnippet = bigsnippet + snippet;
            }
        }
        $('.data').append(bigsnippet);
    }


    mydata = data;

    //$('.data').html(data);
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
