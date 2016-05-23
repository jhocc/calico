import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'
import PageNotFound from 'components/PageNotFound'

describe('PageNotFound', () => {
  it('renders Page Not Found', () => {
    var component = TestUtils.renderIntoDocument(React.createElement(PageNotFound))
    var view = TestUtils.findRenderedDOMComponentWithTag(component, 'h1')
    expect(view.textContent).toContain('Page Not Found')
  })

  it('renders a link to homepage', () => {
    var component = TestUtils.renderIntoDocument(React.createElement(PageNotFound))
    var view = TestUtils.findRenderedDOMComponentWithTag(component, 'a')
    expect(view.textContent).toContain('Home Page')
  })
})
