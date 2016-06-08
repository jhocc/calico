$(document).on('error-explanation:present', function(event) {
  var target = $(event.target)
  $(target).on('click', 'a', () => {
    target.fadeOut('slow')
  })
})
