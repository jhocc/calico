import ChannelNav from 'components/ChannelNav'
import Immutable from 'immutable'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'

describe('ChannelNav', () => {
  describe('lastMessageCreatedAt', () => {
    it("returns the last message's created at, when messages are not empty", () => {
      const messages = Immutable.fromJS([{
        id: 1,
        created_at: "2016-06-06T16:16:00.000Z",
      }, {
        id: 3,
        created_at: "2016-06-06T16:16:05.000Z",
      }, {
        id: 2,
        created_at: "2016-06-06T16:16:01.000Z",
      }])
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.lastMessageCreatedAt(messages)).toEqual('2016-06-06T16:16:05.000Z')
    })

    it("returns null, when messages are empty", () => {
      const messages = Immutable.fromJS([])
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.lastMessageCreatedAt(messages)).toEqual(null)
    })
  })

  describe('channelClass', () => {
    it('returns read when the last_message_created_at is null', () => {
      const readAt = '2016-06-06T16:16:03.000Z'
      const lastMessageCreatedAt = null
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.channelClass(readAt, lastMessageCreatedAt)).toEqual('read')
    })

    it('returns unread when the read_at is null', () => {
      const readAt = null
      const lastMessageCreatedAt = '2016-06-06T16:16:03.000Z'
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.channelClass(readAt, lastMessageCreatedAt)).toEqual('unread')
    })

    it('returns unread when the read_at is earlier than when the last message was created', () => {
      const readAt = '2016-06-06T16:16:01.000Z'
      const lastMessageCreatedAt = '2016-06-06T16:16:03.000Z'
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.channelClass(readAt, lastMessageCreatedAt)).toEqual('unread')
    })

    it('returns read when the read_at is equal to when the last message was created', () => {
      const readAt = '2016-06-06T16:16:01.000Z'
      const lastMessageCreatedAt = '2016-06-06T16:16:01.000Z'
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.channelClass(readAt, lastMessageCreatedAt)).toEqual('read')
    })

    it('returns read when the read_at is laster than when the last message was created', () => {
      const readAt = '2016-06-07T16:16:01.000Z'
      const lastMessageCreatedAt = '2016-06-06T16:16:01.000Z'
      const view = TestUtils.renderIntoDocument(
        <ChannelNav />
      )
      expect(view.channelClass(readAt, lastMessageCreatedAt)).toEqual('read')
    })
  })

  describe('render', () => {
    var view
    var onChannelSelectSpy

    describe('when there is data present', () => {
      beforeEach(() => {
        const fry = {
          user_id: 44,
          user: {
            first_name: 'Phillip',
            last_name: 'Fry',
            profile_photo: { small: { url: 'frys_profile_url' } }
          }
        }
        const leela = {
          user_id: 55,
          user: {
            first_name: 'Turanga',
            last_name: 'Leela',
            profile_photo: { small: { url: 'leelas_profile_url' } }
          }
        }
        const bender = {
          user_id: 66,
          user: {
            first_name: 'Bender',
            last_name: 'Rodriguez',
            profile_photo: { small: { url: 'benders_profile_url' } }
          }
        }
        const unreadMessage = {
          id: 1,
          created_at: '2016-06-06T16:17:01.000Z'
        }
        const readMessage = {
          id: 1,
          created_at: '2016-06-05T16:17:01.000Z'
        }
        const unreadMe = {
          user_id: 77,
          user: { first_name: 'Me', last_name: 'And Myself' },
          read_at: '2016-06-06T16:14:01.000Z'
        }
        const readMe = {
          user_id: 77,
          user: { first_name: 'Me', last_name: 'And Myself' },
          read_at: readMessage.created_at
        }
        const data = Immutable.fromJS([{
          id: 1,
          channels_users: [fry, readMe],
          messages: [readMessage],
        }, {
          id: 2,
          channels_users: [leela, unreadMe],
          messages: [unreadMessage],
        }, {
          id: 3,
          channels_users: [readMe, bender],
          messages: [readMessage],
        }])
        onChannelSelectSpy = jasmine.createSpy('onChannelSelectSpy')
        view = TestUtils.renderIntoDocument(
          <ChannelNav
            data={data}
            onChannelSelect={onChannelSelectSpy}
            activeChannel={1}
            currentUserId={readMe.user_id}
          />
        )
      })

      it('lists the users for each channel as links', () => {
        const channelLinks = TestUtils.scryRenderedDOMComponentsWithTag(view, 'a')
        expect(channelLinks.length).toEqual(3)
        expect(channelLinks[0].textContent).toContain('Phillip Fry')
        expect(channelLinks[1].textContent).toContain('Turanga Leela')
        expect(channelLinks[2].textContent).toContain('Bender Rodriguez')

        const channelProfiles = TestUtils.scryRenderedDOMComponentsWithTag(view, 'img')
        expect(channelProfiles.length).toEqual(3)
        expect(channelProfiles[0].src).toContain('frys_profile_url')
        expect(channelProfiles[1].src).toContain('leelas_profile_url')
        expect(channelProfiles[2].src).toContain('benders_profile_url')
      })

      it('calls onChannelSelect with channel index when a channel link is clicked', () => {
        const channelLinks = TestUtils.scryRenderedDOMComponentsWithTag(view, 'a')
        TestUtils.Simulate.click(channelLinks[1])
        expect(onChannelSelectSpy).toHaveBeenCalledWith(2)
      })

      it('adds the active class to the active channel', () => {
        const activeChannel = TestUtils.findRenderedDOMComponentWithClass(view, 'active')
        expect(activeChannel.textContent).toContain('Phillip Fry')
      })

      it('adds the read class to channels that have been read', () => {
        const readChannel = TestUtils.findRenderedDOMComponentWithClass(view, 'read')
        expect(readChannel.textContent).toContain('Bender Rodriguez')
      })

      it('adds the unread class to channels that have been read', () => {
        const unreadChannel = TestUtils.findRenderedDOMComponentWithClass(view, 'unread')
        expect(unreadChannel.textContent).toContain('Turanga Leela')
      })
    })

    describe('when there is no data present', () => {
      beforeEach(() => {
        const data = Immutable.List()
        view = TestUtils.renderIntoDocument(<ChannelNav data={data} />)
      })

      it('no channel links are listed', () => {
        const channelLinks = TestUtils.scryRenderedDOMComponentsWithTag(view, 'a')
        expect(channelLinks.length).toEqual(0)
      })
    })
  })
})
