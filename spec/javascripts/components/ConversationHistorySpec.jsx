import ConversationHistory from 'components/ConversationHistory'
import Immutable from 'immutable'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'

describe('ConversationHistory', () => {
  describe('shouldComponentUpdate', () => {
    const channel = Immutable.fromJS({
      messages: [],
      channels_users: [{
        user_id: 1,
        user: {
          first_name: 'Me',
          last_name: 'Myself',
          email: 'me_myself@casecommons.org',
        },
      }, {
        user_id: 3,
        user: {
          first_name: 'Calico Feedback',
          last_name: 'User',
          email: 'calico_feedback_user@casecommons.org',
        },
      }],
      created_at: '2016-06-03T11:31:40.163Z',
    })
    const view = TestUtils.renderIntoDocument(<ConversationHistory channel={channel} currentUserId={1}/>)


    it('returns true when channel is undefined', () => {
      const view = TestUtils.renderIntoDocument(<ConversationHistory channel={undefined} />)
      expect(view.shouldComponentUpdate()).toBe(true)
    })

    it('returns true when channel messages changed', () => {
      const view = TestUtils.renderIntoDocument(<ConversationHistory channel={channel} />)
      const channelWithUpdatedMessages = channel.setIn(['messages', 0, 'id'], 1)
      expect(view.shouldComponentUpdate({channel: channelWithUpdatedMessages})).toBe(true)
    })

    it('returns false when channel messages did not change', () => {
      const view = TestUtils.renderIntoDocument(<ConversationHistory channel={channel} />)
      expect(view.shouldComponentUpdate({channel: channel})).toBe(false)
    })
  })

  describe('render', () => {
    describe('when the channel user is the calico feedback user', () => {
      it('renders the welcome message as the first message', () => {
        const channel = Immutable.fromJS({
          messages: [],
          channels_users: [{
            user_id: 1,
            user: {
              first_name: 'Me',
              last_name: 'Myself',
              email: 'me_myself@casecommons.org',
            },
          }, {
            user_id: 3,
            user: {
              first_name: 'Calico Feedback',
              last_name: 'User',
              email: 'calico_feedback_user@casecommons.org',
              profile_photo: { small: { url: 'calico_profile_url' } },
            },
          }],
          created_at: '2016-06-03T11:31:40.163Z',
        })
        const view = TestUtils.renderIntoDocument(<ConversationHistory channel={channel} currentUserId={1}/>)
        const messageView = TestUtils.findRenderedDOMComponentWithClass(view, 'message-window')
        expect(messageView.textContent).toContain(
          'Welcome to Calico, a messaging app for caseworkers, birth and foster parents,'
        )
        expect(messageView.textContent).toContain('Calico Feedback User')
        expect(messageView.textContent).toContain('Calico Feedback User')
        expect(messageView.textContent).toContain('6/3, 7:31 am')

        const profileView = TestUtils.findRenderedDOMComponentWithTag(view, 'img')
        expect(profileView.src).toContain('calico_profile_url')
      })

      describe('when the channel user is NOT the calico feedback user', () => {
        it('does NOT render the welcome message as the first message', () => {
          const channel = Immutable.fromJS({
            messages: [],
            channels_users: [{
              user_id: 1,
              user: {
                first_name: 'Me',
                last_name: 'Myself',
                email: 'me_myself@casecommons.org',
                profile_photo: { small: { url: 'my_profile_url' } }
              },
            },{
              user_id: 3,
              user: {
                first_name: 'Phillip',
                last_name: 'Fry',
                email: 'not_the_feedback_users_email@casecommons.org',
                profile_photo: { small: { url: 'frys_profile_url' } }
              },
            }],
          })
          const view = TestUtils.renderIntoDocument(<ConversationHistory channel={channel} currentUserId={1} />)
          const messageView = TestUtils.findRenderedDOMComponentWithClass(view, 'message-window')
          expect(messageView.textContent).not.toContain(
            'Welcome to Calico, a messaging app for caseworkers, birth and foster parents,'
          )
        })
      })
    })

    it('renders the current channels messages', () => {
      const channel = Immutable.fromJS({
        messages: [{
          id: 1,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
            profile_photo: { small: { url: 'frys_profile_url' } }
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

      const messageViewImg = TestUtils.findRenderedDOMComponentWithTag(view, 'img')
      expect(messageViewImg.src).toContain('frys_profile_url')
    })
  })
})
