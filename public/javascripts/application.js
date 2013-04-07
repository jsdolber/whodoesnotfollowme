// Put your application scripts here
//

$(document).ready(function(){

//init
$(".icon-leaf").toggle();
$("#results").toggle();
$("#loading-bar").toggle();
$("#err-modal").toggle();
$("#info-modal").toggle();
$("#search-button").fadeTo(1, 0.5);
$("#search-button").hover(function(){$(this).fadeTo(1, 1)});
$(".hero-unit").hover(function(){$("#search-button").fadeTo(1, 0.5)});
$("#av").toggle();
var request;

$(document).keypress(function(e) {
  if(e.which == 13 && $("#search-input").is(":focus")) {
    $("#search-button").click();
  }
});

if (!is_auth) {
  $("#search-button").click(function() {
    $.cookie('pre-name', $("#search-input").val());
    location.href = '/auth/twitter';
  });
}
else {

  if ($.cookie('pre-name') !== undefined) {
    $("#search-input").val($.cookie('pre-name'));
    $.removeCookie('pre-name');
    make_request($("#search-input").val());
  }

  $("#search-button").click(function (e) {
      e.preventDefault();
      make_request($("#search-input").val());
  });
}

function make_request(name) {
  if (request) {
        request.abort();
  }

  request = $.ajax({
        url: "/unfollowers",
        type: "post",
        data: {'name': $("#search-input").val()}
  });

  $("#loading-bar").show();
  $(".icon-refresh").show();
  $(".icon-leaf").hide();

  request.done(function (data, textStatus, jqXHR){
    $("#err-modal").hide();
    $("#info-modal").hide();
    $("#results").hide();

    if (data.msg) {
      $("#err-msg").html(data.msg);
      $("#err-modal").show();
      return;
    }

    if (data.length == 0) {
      $("#info-msg").html("<strong>Yay!</strong> Everyone follows you back.");
      $("#info-modal").show();
      return;
    }

    for (var i = 0; i < data.length; i++) {
      var rec = data[i];
      $("#tbl-results").find('tbody')
          .append($('<tr>')
              .append($('<td>')
                  .append($('<img>')
                    .attr('src', rec.avatar)
                    .addClass('img-rounded')
                  ).addClass('img-td').css('text-align', 'center')
              )
              .append($('<td>')
                  .append($('<span>')
                    .html('@' + rec.screen_name).addClass('twuser')
                  )
                  .append($('<small class="visible-desktop visible-tablet">')
                    .html(rec.name).addClass('twname')
                  )
              )
              .append($('<td>')
                  .append($('<a>')
                  .addClass('unfollow btn btn-large btn-primary')
                  .text("unfollow")
                  .attr('href', 'http://twitter.com/' + rec.screen_name)
                  .attr('target', '_blank')
                  )
              )
       );
    }

    $("#results").slideDown(300);

  });

  request.fail(function (jqXHR, textStatus, errorThrown){
      $("#err-modal").hide();
      $("#info-modal").hide();
      $("#results").hide();
      $("#err-msg").html("<strong>Oops!</strong> Something went wrong, sorry about that.");
      $("#err-modal").show();
  });

  request.always(function () {
    $(".icon-leaf").show();
    $(".icon-refresh").hide();
  }); 
}

});
