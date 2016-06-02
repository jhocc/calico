$(() => {
  $('html').click(function() {
    $('.drawer').removeClass('open')
  });

  $('.drawer').click(function(event){
    if ($(event.target).is('a[data-method]')) {
      return true;
    } else {
      event.stopPropagation();
    }
  });
})
