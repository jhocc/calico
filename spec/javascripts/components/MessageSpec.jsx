import Message from 'components/Message'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'

describe('Message', () => {
  describe('render', () => {
    const view = TestUtils.renderIntoDocument(
      <Message profileUrl='frys_profile_url' username='Phillip Fry' createdAt='6/2, 6:31 pm'>
        <p>Hi there!</p>
      </Message>
    )

    it('renders the contents', () => {
      const messageView = TestUtils.findRenderedDOMComponentWithClass(view, 'message')
      expect(messageView.textContent).toContain('Hi there!')
    })

    it('renders the username and createdAt', () => {
      const messageView = TestUtils.findRenderedDOMComponentWithClass(view, 'message')
      expect(messageView.textContent).toContain('Phillip Fry')
      expect(messageView.textContent).toContain('6/2, 6:31 pm')
    })

    it('renders the profile image', () => {
      const messageViewImg = TestUtils.findRenderedDOMComponentWithTag(view, 'img')
      expect(messageViewImg.src).toContain('frys_profile_url')
    })
  })
})
