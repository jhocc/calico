'use strict'

import React, { Component, DOM } from 'react'
import ReactDOM from 'react-dom'
import HelloReact from 'components/HelloReact'

var node = document.getElementById('container')

ReactDOM.render(React.createElement(HelloReact), node)
