var entered = false;

var rotate_factor = 0;

$(document).ready(function () {

    //set prio for when player joins
    $(".multichar-container").show();
    $(".delete-container").hide();
    $(".create-container").hide();

    $(".create-container").removeClass("hidden");
    $(".delete-container").removeClass("hidden");

    window.addEventListener('message', function (event) {
        var data = event.data;

        if (data.type === "charSelect") {
            if (data.status == true) {
                $(".multichar-container").fadeIn(250);
            } else {
                $(".multichar-container").fadeOut(250);
            }
        }

        if (data.type === "setupCharacters") {
            var characters = data.characters;
            if (characters !== null) {
                $.each(characters, function (index, char) {
                    $('[data-charid=' + char.cid + ']').html('');
                    $('[data-charid=' + char.cid + ']').html('' +
                        // formatted for easier reading
                        '<div class="slot-name">' +
                        '<div class="slot-name-wrapper"><p><span id="slot-player-name">' + char.firstname + ' ' + char.lastname +'</span></p><br>' +
                        '<button class="play-button" data-cid="' + char.cid + '">Select</button></br><br>' +
                        '<button class="delete-button" data-cid="' + char.cid + '">Perma</button></br></div>'
                    );
                })
            }
        }

        $(".play-button").click(function (e) {
            e.preventDefault();
            var characterid = $(this).data('cid');

            $.post('http://MP-Base/selectCharacter', JSON.stringify({
                cid: characterid
                // close UI
            }));

            $(".multichar-container").fadeOut(250);
            $(".body-wrapper").hide();
        });

        $(".delete-button").click(function (e) {
            e.preventDefault();
            var characterid = $(this).data('cid');
            $(".multichar-container").fadeOut(250);
            $(".delete-container").fadeIn(250);
            $(".accept-delete").data('cid', characterid);

        });

        document.onkeyup = function (data) {
            if (data.which == 13) {
                if (entered === false) {
                    entered = true;
                    $('.welcomescreen').fadeOut(250)
                    $('#myProgress').fadeIn(250)
                    move()
                    loadingText()
                    retrieveData()
                    return
                }
            }
        };
    });
});

$('.branding-logo').click(function(){
    $(this).css({
        "-webkit-transform": "rotate(90deg)",
        "-moz-transform": "rotate(90deg)",
        "transform": "rotate(90deg)" /* For modern browsers(CSS3)  */
    });
});


$("#accept-delete").click(function (e) {
    e.preventDefault();
    var characterid = $(this).data('cid')
    $.post('http://MP-Base/deleteCharacter', JSON.stringify({
        cid: characterid,
        firstname: $('#firstname').val(),
        lastname: $('#lastname').val(),
    }));
    entered = false;
    $(".delete-container").hide();
    location.reload();
    setTimeout(function () {        
        $('[data-charid=' + characterid + ']').html('<button class="create-button" id="create-cid-' + characterid + '">New Character</button><div class="slot-name"><p><span id="slot-player-name"></span></p></div>')
    }, 500);
    
    $(".multichar-container").show();
});

$(".create-button").click(function (e) {
    e.preventDefault();
    var cid = $(this).data('cid');
    $(".multichar-container").fadeOut(500);
    $(".create-container").fadeIn(250);
    $(".accept-create").data('cid', cid);
});

// SF - better functionality for my own processes
$(".cancel-button").click(function (e) {
    e.preventDefault();
    var element = document.getElementById("create-modal");
    // element.classList.add("hidden");

    $(".create-container").fadeOut(250);
    $(".multichar-container").fadeIn(250)
});

$("#deny-delete").click(function (e) {
    e.preventDefault();
    $(".multichar-container").fadeIn(250);
    $(".delete-container").fadeOut(250);
});

$(".accept-create").click(function (e) {

    e.preventDefault();
    var charid = $(this).data('cid');
    var data = {
        firstname: $('#firstname').val(),
        lastname: $('#lastname').val(),
        sex: $('#sex').val(),
        dob: $('#dob').val(),
        cid: charid
    };

    // Need to sanitize these inputs...

    $.post('http://MP-Base/createCharacter', JSON.stringify({
        charData: data
    }))
    entered = false;
    $(".create-container").fadeOut(250);

    $(".multichar-container").fadeIn(250);

});

