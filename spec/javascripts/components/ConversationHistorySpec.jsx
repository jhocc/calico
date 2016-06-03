import ConversationHistory from 'components/ConversationHistory'
import Immutable from 'immutable'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'

describe('ConversationHistory', () => {
  describe('render', () => {
    it('renders the current channels messages', () => {
      const channel = Immutable.fromJS({
        messages: [{
          id: 1,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
          created_at: '2016-06-02T22:31:40.163Z',
          content: 'Hi there!'
        }],
        channels_users: [{
          user_id: 5,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
        }],
      })
      const view = TestUtils.renderIntoDocument(<ConversationHistory channel={channel}/>)
      const messageView = TestUtils.findRenderedDOMComponentWithClass(view, 'message-window')
      expect(messageView.textContent).toContain('Hi there!')
      expect(messageView.textContent).toContain('Phillip Fry')
      expect(messageView.textContent).toContain('6/2, 6:31 pm')
    })
  })
})
