var seen = false;

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var data = event.data;
        if (event.data.action == "toggle") {
            if (seen) {
                $('.container').fadeOut();
            } else {
                $('.container').fadeIn();
            }
            seen = !seen;
        }

        if (event.data.action == "show") {
            $('.container').fadeIn();
            seen = true;
        }

        if (event.data.action == "hide") {
            $('.container').fadeOut();
            seen = false;
        }

        if (event.data.action == "setValue") {
            setValue(data.key, data.value)
        }

        if (event.data.action == "addcash") {
            var element = $("<div class='cashchange'><font style='color: rgb(255, 255, 255); font-weight: 700;hasrfa margin-right: 6px;'>+ <span id='dollar-plus'>$  </span>" + data.value + "</font></div>");
            $("#cashchange").append(element);
            setTimeout(function () {
                $(element).fadeOut(1000, function () { $(this).remove(); });
            }, 1000);
        }

        if (event.data.action == "removecash") {
            var element = $("<div class='cashchange'><font style='color: rgb(255, 255, 255); font-weight: 700;hasrfa margin-right: 6px;'>- <span id='dollar-min'>$  </span>" + data.value + "</font></div>");
            $("#cashchange").append(element);
            setTimeout(function () {
                $(element).fadeOut(1000, function () { $(this).remove(); });
            }, 1000);
        }

        if (event.data.action == "updateValue") {
            updateValue(data.key, data.value)
        }


        // Notis
        if (data.runNoti === true) {
            var msg = data.text
            var timer = data.time
            var element
            $('#color' + data.color ).css('display', 'none');
            if (data.color == 1) {
                element = $('<div id="color' + data.color + '" class="noti-bg blue" style="display:none">' + msg + '</div>'); 
            } else if (data.color == 2) {
                element = $('<div id="color' + data.color + '"class="noti-bg red" style="display:none">' + msg + '</div>');
            } else if (data.color == 3) {
                element = $('<div id="color' + data.color + '"class="noti-bg green" style="display:none">' + msg + '</div>');
            }

            $('.wrapdiv').prepend(element);
            $(element).fadeIn(500);
            setTimeout(function(){
                $(element).fadeOut(timer-(timer/2));
            }, timer);
        }
    });
});

function setValue(key, value) {
    $('#' + key).html("<span id='dollar'>$  </span>" + value)
}

function updateValue(key, value) {
    $('#' + key).html("<span id='dollar'>$  </span>" + value)
}