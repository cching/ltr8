$(document).on('ready', function(){
    $('#readonly_rating').rating({
    	displayOnly: true, 
    	step: 0.5,
    	size: "sm"
    });

    $('.readonly_rating_xs').rating({
    	displayOnly: true, 
    	step: 0.1,
    	size: "xs"
	});
});


$(function() {
  $(".sort_paginate_ajax").on("click", ".pagination a", function(){
    $.getScript(this.href);
    return false;
  });
});