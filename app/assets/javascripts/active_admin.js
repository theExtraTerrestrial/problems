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

  $('.read-more').on('click', function(e){
  	e.preventDefault();
  	$('.ul-main').toggle();
  });

  // function toggleElements (a) {
  //   var divs = document.getElementsByClassName(a);
  //   var i;
  //   var x;
  //   for (i = 0; i < divs.length; i++) {
  //     if (divs[i].children.length > 2) {
  //       for (x = 0; x < divs[i].children.length; x++) {
  //         var child = divs[i].children[x];
  //         if (!(child.className == 'ul-header')) {
  //         child.style.display = 'none';
  //         };
  //       };
  //     };
  //   };
  // }
})
