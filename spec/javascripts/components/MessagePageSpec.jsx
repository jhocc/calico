import * as Util from 'util/http'
import ChannelNav from 'components/ChannelNav'
import Immutable from 'immutable'
import MessagePage from 'components/MessagePage'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'

describe('MessagePage', () => {
  describe('componentDidMount', () => {
    var xhrRequest
    beforeEach(() => {
      spyOn(Util, 'request')
      xhrRequest = jasmine.createSpyObj('xhr request', ['done'])
      Util.request.and.returnValue(xhrRequest)
    })

    it('requests channels from message api', () => {
      TestUtils.renderIntoDocument(<MessagePage currentUserId={1} />)
      expect(Util.request).toHaveBeenCalledWith('GET', '/messages.json', null)
      expect(xhrRequest.done).toHaveBeenCalledWith(jasmine.any(Function))
    })
  })

  describe('filterUserChannelsOfCurrent', () => {
    var currentUserId
    var channels
    var view

    beforeEach(() => {
      currentUserId = 1
      const channel_one = {
        channels_users: [{
          user_id: 5,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
        }, {
          user_id: currentUserId,
          user: {
            first_name: 'Me',
            last_name: '& Myself',
          },
        }]
      }
      const channel_two = {
        channels_users: [{
          user_id: 6,
          user: {
            first_name: 'Turunga',
            last_name: 'Leela',
          },
        }, {
          user_id: currentUserId,
          user: {
            first_name: 'Me',
            last_name: '& Myself',
          },
        }]
      }
      channels = Immutable.fromJS([ channel_one, channel_two ])
      view = TestUtils.renderIntoDocument(<MessagePage />)
    })

    it('filters out channel users who match current user id', () => {
      const filteredChannels = view.filterUserChannelsOfCurrent(channels, currentUserId)
      expect(filteredChannels.toJS()).toEqual([{
        channels_users: [{
          user_id: 5,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
        }],
      }, {
        channels_users: [{
          user_id: 6,
          user: {
            first_name: 'Turunga',
            last_name: 'Leela',
          },
        }]
      }])
    })
  })

  describe('render', () => {
    var view
    describe('when there are channels present', () => {
      beforeEach(() => {
        const currentUserId = 1
        const channel_one = {
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
        }
        view = TestUtils.renderIntoDocument(<MessagePage currentUserId={currentUserId} />)
        view.setState({ channels: Immutable.fromJS([channel_one]) })
      })

      it('renders the channel nav with non current user labels', () => {
        const channelView = TestUtils.findRenderedComponentWithType(view, ChannelNav)
        expect(channelView.props.data.toJS()).toEqual([{
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
        }])
      })

      it('renders the conversation header with selected channel', () => {
        const channelView = TestUtils.findRenderedDOMComponentWithClass(view, 'conversation-header')
        expect(channelView.textContent).toContain('Phillip Fry')
      })

      it('renders the current channels messages', () => {
        const messageView = TestUtils.findRenderedDOMComponentWithClass(view, 'message-window')
        expect(messageView.textContent).toContain('Hi there!')
        expect(messageView.textContent).toContain('Phillip Fry')
        expect(messageView.textContent).toContain('6/2, 6:31 pm')
      })

      it('renders a message input view and send button', () => {
        const textarea = TestUtils.findRenderedDOMComponentWithTag(view, 'textarea')
        expect(textarea.getAttribute('placeholder')).toEqual('Type your message here...')

        const button = TestUtils.findRenderedDOMComponentWithClass(view, 'btn-success')
        expect(button.value).toEqual('Send')
      })
    })

    describe('when there are no channels present', () => {
      beforeEach(() => {
        view = TestUtils.renderIntoDocument(<MessagePage currentUserId={1} />)
      })

      it('renders the channel nav with no data', () => {
        const channelView = TestUtils.findRenderedComponentWithType(view, ChannelNav)
        expect(channelView.props.data.toJS()).toEqual([])
      })
    })
  })
})
