import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'
import HelloReact from 'components/HelloReact'

describe('HelloReact', () => {
  it('renders Hello World', () => {
    var component = TestUtils.renderIntoDocument(React.createElement(HelloReact))
    var view = TestUtils.findRenderedDOMComponentWithTag(component, 'div')
    expect(view.textContent).toContain('Hello World')
  })
})
