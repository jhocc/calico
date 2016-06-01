import 'jquery-helpers'
import 'babel-polyfill'
import React, { Component, DOM } from 'react'
import ReactDOM from 'react-dom'
import rails from 'jquery-ujs'
import 'vendor/drawer'
import 'menu'
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
}
present()
