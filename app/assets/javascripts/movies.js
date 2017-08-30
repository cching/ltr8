$(document).ready(function () {
    $('.parallax').parallax();
    // initiate intro now playing backdrop parallax on page load
    $('select').material_select();
    // initialize material form select
    $(document).on("scroll", onScroll);
    
    if ($("#parallax_container") != null) {
    	// only load AJAX requests on home page with valid object
    	loadCategories();

		var replaceInt = setInterval(replaceHomeNP, 10000);

		i = 1;
		function replaceHomeNP() {
		    $.get("/movies/refresh_now_playing/" + i, 
		    {});
		    i++; 
		    if (i == 20) { 
		    	clearInterval(replaceInt);   
			}
			// kill loop after 20th iteration of now playing array
		}
	}
  
});

function onScroll(event){
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
		$.get("/movies/home_assets/", 
    { });
	
}
