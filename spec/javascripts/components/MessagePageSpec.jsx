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
        user_id: 5,
        user: {
          first_name: 'Phillip',
          last_name: 'Fry',
        },
      }, {
        user_id: 6,
        user: {
          first_name: 'Turunga',
          last_name: 'Leela',
        },
      }])
    })
  })

  describe('render', () => {
    var view
    describe('when there are channels present', () => {
      beforeEach(() => {
        const currentUserId = 1
        const channel_one = {
          user_id: 5,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
        }
        view = TestUtils.renderIntoDocument(<MessagePage currentUserId={currentUserId} />)
        view.setState({ channels: Immutable.fromJS([channel_one]) })
      })

      it('renders the channel nav with non current user labels', () => {
        const channelView = TestUtils.findRenderedComponentWithType(view, ChannelNav)
        expect(channelView.props.data.toJS()).toEqual([{
          user_id: 5,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
        }])
      })

      it('renders the conversation header with selected channel', () => {
        const channelView = TestUtils.findRenderedDOMComponentWithClass(view, 'conversation-header')
        expect(channelView.textContent).toContain('Phillip Fry')
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
