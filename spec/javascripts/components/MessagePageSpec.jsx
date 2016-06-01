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

  describe('render', () => {
    var view
    describe('when there are channels present', () => {
      beforeEach(() => {
        const currentUserId = 1
        view = TestUtils.renderIntoDocument(<MessagePage currentUserId={currentUserId} />)
        const channel_one = {
          id: 7,
          channels_users: [{
            id: 11,
            user_id: 5,
            user: {
              first_name: 'Phillip',
              last_name: 'Fry',
            },
            channel_id: 7,
          }, {
            id: 12,
            user_id: currentUserId,
            user: {
              first_name: 'Me',
              last_name: '& Myself',
            },
            channel_id: 7,
          }]
        }
        const channel_two = {
          id: 8,
          channels_users: [{
            id: 13,
            user_id: 6,
            user: {
              first_name: 'Turunga',
              last_name: 'Leela',
            },
            channel_id: 8,
          }, {
            id: 14,
            user_id: currentUserId,
            user: {
              first_name: 'Me',
              last_name: '& Myself',
            },
            channel_id: 8,
          }]
        }
        view.setState({ channels: Immutable.fromJS([ channel_one, channel_two ]) })
      })

      it('renders the channel nav with non current user labels', () => {
        const channelView = TestUtils.findRenderedComponentWithType(view, ChannelNav)
        expect(channelView.props.data.toJS()).toEqual([{
          id: 11,
          user_id: 5,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
          },
          channel_id: 7,
        }, {
          id: 13,
          user_id: 6,
          user: {
            first_name: 'Turunga',
            last_name: 'Leela',
          },
          channel_id: 8,
        }])
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
