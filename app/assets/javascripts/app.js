import 'jquery-helpers'
import 'babel-polyfill'
import React, { Component, DOM } from 'react'
import ReactDOM from 'react-dom'
import rails from 'jquery-ujs'
import 'vendor/drawer'
import 'menu'
import 'error-explanation'
import MessagePage from 'components/MessagePage'
import 'presenter'
import _ from 'lodash'

function bindAndRenderReact(eventName, Component, dataAttrs = [], dataTransformer = (x) => x) {
  $(document).bind(eventName, (event) => {
    const el = event.target
    const props = dataTransformer(_.pick($(el).data(), dataAttrs))
    ReactDOM.render(<Component {...props} />, el)
  })
}

function present() {
  $(document).ready(function() {
    window.present($('body'))
  })

  if ($.isReady) {
    throw new Error('DOM already ready, too late to bind')
  }
  bindAndRenderReact('MessagePage:present', MessagePage, ['currentUserId', 'activeChannel'])
}
present()
