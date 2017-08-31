$(document).ready(function () {
    $('.parallax').parallax();
    // initiate intro now playing backdrop parallax on page load
    $('#genres').material_select();
    // initialize material form select
    $(document).on("scroll", onScroll);
    
    var homepage = (window.location.pathname == '/');
    if (homepage) {
    	// only load AJAX requests on home page with valid object
    loadCategories();

		var replaceInt = setInterval(replaceHomeNP, 10000);

		i = 1;
		function replaceHomeNP() {
		    $.get("/movies/refresh_now_playing/" + i, 
		    {});
		    i++; 
		    if (i == 20 || !homepage) { 
		    	clearInterval(replaceInt);   
			}
			// kill loop after 20th iteration of now playing array
		}
	}

  $(".sort_btn").on("click", function(e) {
    // on click function for title and release date sorting
    var value = $(this).attr("value");
    var hidden_field = $('#' + value + '_sort');
    e.target.blur();

    if (hidden_field.val() == '' || hidden_field.val() == undefined) {
      hidden_field.val(value + '.asc');
      $('#' + value + '> :first-child').html("keyboard_arrow_down");
      // if no sorting option, set to ascending first
    } else {
      // if there is a value:
      if (hidden_field.val().slice(-3) == "asc") {
        hidden_field.val(value + '.desc');
        $('#' + value + '> :first-child').html("keyboard_arrow_up");
        // if on click event object was ascending, switch to descending
      } else {
        hidden_field.val('');
        $('#' + value + '> :first-child').html("");
        // if on click event object was descending, switch to empty sorting
      }
    }
    removeSort(value);
    $("#movie_container").html("");
    $("#search_form").submit();
    // submit form after attaching correct values and changing keyboard arrows
  })

  $("#genres").on('change', function() {
    // remove both sorting options from dropdowns, remove title query and submit form
    $("#title").val('');
    Materialize.updateTextFields();
    $("#movie_container").html("");
    $("#search_form").submit();
  });

  $('#title').keyup(function() {
    delay(function(){
      // submit form and clear other values after 0.5s after last keyup in title search
      $('#genres').val("0");
      $('#genres').material_select();
      removeBothSort();
      $("#movie_container").html("");
      $("#search_form").submit();
    }, 500 );
  });
});

function removeSort(id) {
  $("#title").val('');
  Materialize.updateTextFields();
  $(".sort_btn").each(function (){
    if (id != this.id) {
      $('#' + this.id + '_sort').val('');
      $('#' + this.id + '> :first-child').html("");
      // if one sort button selected, disable sorting options of other
    }
  });
}

function removeBothSort() {
  $(".sort_btn").each(function (){
        $('#' + this.id + '_sort').val('');
        $('#' + this.id + '> :first-child').html("");
        // if one sort button selected, disable sorting options of other
  });
}

function onScroll(event){
  // change navbar to scrolled class once scroll initiates
  if($(document).scrollTop() > 50) {
    $(".navbar-fixed-top").addClass("scrolled");
    $(".navbar-right").addClass("scrolled");
    $(".brand-logo").addClass("scrolled");
  } else {
    $(".navbar-fixed-top").removeClass("scrolled");
    $(".navbar-right").removeClass("scrolled");
    $(".brand-logo").removeClass("scrolled");
  }
}

// function to change transparency and colors of navbar
function loadCategories() {
  // use ajax to get posters and categories on home page
	$.get("/movies/home_assets/", 
  { });

  $.get("/movies/search/", 
  { });
}

var delay = (function(){
  //https://stackoverflow.com/questions/1909441/how-to-delay-the-keyup-handler-until-the-user-stops-typing
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

