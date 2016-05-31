$('html').click(function() {
  $('.drawer').removeClass('open')
});

$('.drawer').click(function(event){
    event.stopPropagation();
});