//= require active_admin/base
//= require jquery-ui
//= require jquery_ujs
//= require active_admin_datetimepicker
//= require best_in_place
//= require jquery.purr
//= require best_in_place.purr

$(document).ready(function(){

  jQuery(".best_in_place").best_in_place();

  $('.state_button').bind("ajax:success", function(){
  	$(this).closest('tr').effect('highlight');
  });

  if ($('.ul-div').children().length > 2){
  	$(this).children(":not.('.ul-header')").toggle();
  };

  $('.read-more').on('click', function(e){
  	e.preventDefault();
  	$(this).parent().toggle();
  });

})
