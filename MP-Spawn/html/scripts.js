$(document).ready(function () {
  $(".markerBtn").on("click", function () {
    var markerSet = $(".markerBtn");

    if (markerSet.hasClass("markerBtn-active")) {
      $(".markerBtn").removeClass("markerBtn-active");
    }
    var clicked = $(this).data("location");

    if (clicked == "pink") {
      $(".markerBtn.pink").addClass("pink-active");
      $(".markerBtn.bus").removeClass("bus-active");
      $(".markerBtn.dream").removeClass("dream-active");
      $(".markerBtn.airport").removeClass("airport-active");
      $(".markerBtn.harmony").removeClass("harmony-active");
    } else if (clicked == "bus") {
      $(".markerBtn.pink").removeClass("pink-active");
      $(".markerBtn.bus").addClass("bus-active");
      $(".markerBtn.dream").removeClass("dream-active");
      $(".markerBtn.airport").removeClass("airport-active");
      $(".markerBtn.harmony").removeClass("harmony-active");
    } else if (clicked == "dream") {
      $(".markerBtn.pink").removeClass("pink-active");
      $(".markerBtn.bus").removeClass("bus-active");
      $(".markerBtn.dream").addClass("dream-active");
      $(".markerBtn.airport").removeClass("airport-active");
      $(".markerBtn.harmony").removeClass("harmony-active");
    } else if (clicked == "airport") {
      $(".markerBtn.pink").removeClass("pink-active");
      $(".markerBtn.bus").removeClass("bus-active");
      $(".markerBtn.dream").removeClass("dream-active");
      $(".markerBtn.airport").addClass("airport-active");
      $(".markerBtn.harmony").removeClass("harmony-active");
    } else if (clicked == "harmony") {
      $(".markerBtn.pink").removeClass("pink-active");
      $(".markerBtn.bus").removeClass("bus-active");
      $(".markerBtn.dream").removeClass("dream-active");
      $(".markerBtn.airport").removeClass("airport-active");
      $(".markerBtn.harmony").addClass("harmony-active");
    }

    if (clicked == null) {
      $(".spawn-box").hide;
    } else {
      $(".spawn-box").html(
        '<button class="spawn-btn green spawnBtn" onclick="Spawn(this)"> <i class="fas fa-map-marked-alt"></i>Spawn Here: <span class="spawn-name"> ' +
          $(this).data("info") +
          " </span></button>"
      );
      $(".spawnBtn").data("spawn-name", $(this).data("location"));
      $(".spawn-box").fadeIn(100);
    }
  });

  window.addEventListener("message", function (e) {
    if (e.data.action == "display") {
      $("body").css("background", "rgba(0,0,0,0.7)");
      $(".spawnbackground").removeClass("disabled");
      $(".spawnbackground").fadeIn(500);
    }
  });
});

function Spawn() {
  var location = $(".spawnBtn").data("spawn-name");

  $.post(
    "https://MP-Spawn/spawn",
    JSON.stringify({
      location: location,
    })
  );
  $("body").css("background", "transparent");
  $(".spawn-box").fadeOut(100);
  $(".spawnbackground").fadeOut(300);
}
