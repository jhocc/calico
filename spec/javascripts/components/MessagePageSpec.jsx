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
      expect(Util.request).toHaveBeenCalledWith('GET', '/channels.json', null)
      expect(xhrRequest.done).toHaveBeenCalledWith(jasmine.any(Function))
    })
  })

  describe('send', () => {
    var xhrRequest
    var view
    beforeEach(() => {
      spyOn(Util, 'request')
      xhrRequest = jasmine.createSpyObj('xhr request', ['done'])
      Util.request.and.returnValue(xhrRequest)
      view = TestUtils.renderIntoDocument(<MessagePage currentUserId={1} />)
      spyOn(view, 'getActiveChannelId')
      view.getActiveChannelId.and.returnValue(1)
      const messageInput = view.refs.messageInput;
      messageInput.value = 'Hi there!';
      TestUtils.Simulate.change(view.refs.messageInput);
    })

    it('calls the messages api with the message-input content', () => {
      view.send()
      expect(Util.request.calls.mostRecent().args).toEqual([
        'POST',
        '/channels/1/messages.json',
        {message: {content: 'Hi there!'}}
      ])
    })

    it('clears out the message input field', () => {
      view.send()
      expect(view.refs.messageInput.value).toEqual('')
    })
  })

  describe('mark', () => {
    var xhrRequest
    var view
    beforeEach(() => {
      spyOn(Util, 'request')
      xhrRequest = jasmine.createSpyObj('xhr request', ['done'])
      Util.request.and.returnValue(xhrRequest)
      view = TestUtils.renderIntoDocument(<MessagePage currentUserId={1} />)
      TestUtils.Simulate.change(view.refs.messageInput);
    })

    describe('when the active channel is not null', () => {
      beforeEach(() => {
        spyOn(view, 'getActiveChannelId')
        view.getActiveChannelId.and.returnValue(1)
      })

      it('calls the mark api with the current channel id', () => {
        view.mark()
        expect(Util.request.calls.mostRecent().args).toEqual([
          'PUT',
          '/channels/1/mark.json',
          {channel_id: 1}
        ])
      })
    })

    describe('when the active channel is null', () => {
      beforeEach(() => {
        spyOn(view, 'getActiveChannelId')
        view.getActiveChannelId.and.returnValue(null)
      })

      it('does not call the mark api', () => {
        view.mark()
        expect(Util.request.calls.mostRecent().args).not.toEqual([
          'PUT',
          '/channels/null/mark.json',
          {channel_id: null}
        ])
      })
    })
  })

  describe('setActiveChannel', () => {
    var view
    beforeEach(() => {
      view = TestUtils.renderIntoDocument(<MessagePage currentUserId={1} />)
      spyOn(view, 'setState')
      spyOn(view, 'mark')
    })

    it('sets the active channel and calls mark', () => {
      view.setActiveChannel(2)
      expect(view.setState).toHaveBeenCalledWith({activeChannel: 2})
      expect(view.mark).toHaveBeenCalled()
    })
  })

  describe('render', () => {
    var view
    describe('when there are channels present', () => {
      beforeEach(() => {
        const currentUserId = 1
        const channel_one = {
          id: 1,
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
          }, {
            user_id: 1,
            user: {
              first_name: 'Me',
              last_name: 'Myself',
              profile_photo: { small: { url: 'my_profile_url' } }
            },
          }],
        }
        view = TestUtils.renderIntoDocument(<MessagePage currentUserId={currentUserId} activeChannel={1} />)
        spyOn(view, 'send')
        view.setState({ channels: Immutable.fromJS([channel_one]) })
      })

      it('renders the channel nav with non current user labels', () => {
        const channelView = TestUtils.findRenderedComponentWithType(view, ChannelNav)
        expect(channelView.props.activeChannel).toEqual(1)
        expect(channelView.props.data.toJS()).toEqual([{
          id: 1,
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
          }, {
            user_id: 1,
            user: {
              first_name: 'Me',
              last_name: 'Myself',
              profile_photo: { small: { url: 'my_profile_url' } }
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

        const messageViewImg = TestUtils.findRenderedDOMComponentWithClass(view, 'my-profile-picture')
        expect(messageViewImg.src).toContain('my_profile_url')

        const button = TestUtils.findRenderedDOMComponentWithClass(view, 'btn-primary')
        expect(button.value).toEqual('Send')
      })

      it('wires up the send button to call send when send button is clicked', () => {
        const button = TestUtils.findRenderedDOMComponentWithClass(view, 'btn-primary')
        expect(button.value).toEqual('Send')
        TestUtils.Simulate.click(button)
        expect(view.send).toHaveBeenCalled()
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
