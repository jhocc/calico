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
import Breezy from '@jho406/breezy'
import {View} from 'components/view'
import 'views/channelz_show'
import 'layouts/default'

if (!window.Breezy) {
  window.Breezy = Breezy
}

window.Breezy.on('breezy:load', (event) => {
  var props = {
    view: event.view,
    data: event.data,
  }

  ReactDOM.render(React.createElement(View, props), document.getElementById('app'))
})

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
