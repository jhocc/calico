import $ from 'jquery'
import moment from 'moment'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'
import Immutable from 'immutable'
import HelloReact from 'components/HelloReact'

describe('Hello React', () => {
  it('should be passed', () => {
    var component = TestUtils.renderIntoDocument(React.createElement(HelloReact))
    var view = TestUtils.findRenderedDOMComponentWithTag(component, 'div')
    expect(view.textContent).toContain('Hello World')
  })
})
