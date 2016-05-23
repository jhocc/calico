'use strict'

import React, { Component, DOM } from 'react'
import ReactDOM from 'react-dom'
import HelloReact from 'components/HelloReact'
import PageNotFound from 'components/PageNotFound'
import { Router, Route, Link, browserHistory } from 'react-router'

var node = document.getElementById('container')

ReactDOM.render((
  <Router history={browserHistory}>
    <Route path="/" component={HelloReact}></Route>
    <Route path="*" component={PageNotFound}/>
  </Router>
), node)
