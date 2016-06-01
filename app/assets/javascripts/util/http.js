import 'jquery-helpers'
import rails from 'jquery-ujs'

function getCSRFToken() {
    return $('meta[name="csrf-token"]').attr('content')
}

export function request(method, url, data) {
  return $.ajax({
    type: method,
    url: url,
    data: data,
    headers: {'X-CSRF-Token': getCSRFToken() },
  })
}
