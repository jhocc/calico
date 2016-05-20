'use strict'

import React, { Component, DOM } from 'react'
import ReactDOM from 'react-dom'

class HelloReact extends Component {
  render() {
    return DOM.div({}, "Hello World")
  }
}

var node = document.getElementById('container')

ReactDOM.render(React.createElement(HelloReact), node)
