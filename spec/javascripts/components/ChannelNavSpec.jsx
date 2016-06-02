import ChannelNav from 'components/ChannelNav'
import Immutable from 'immutable'
import React from 'react'
import ReactDOM from 'react-dom'
import TestUtils from 'react-addons-test-utils'

describe('ChannelNav', () => {
  describe('render', () => {
    var view
    var onChannelSelectSpy

    describe('when there is no data present', () => {
      beforeEach(() => {
        const data = Immutable.fromJS([
          { user: { first_name: 'Phillip', last_name: 'Fry' }},
          { user: { first_name: 'Turanga', last_name: 'Leela'}},
          { user: { first_name: 'Bender', last_name: 'Rodriguez'}},
        ])
        onChannelSelectSpy = jasmine.createSpy('onChannelSelectSpy')
        view = TestUtils.renderIntoDocument(<ChannelNav data={data} onChannelSelect={onChannelSelectSpy}/>)
      })

      it('lists the users for each channel as links', () => {
        const channelLinks = TestUtils.scryRenderedDOMComponentsWithTag(view, 'a')
        expect(channelLinks.length).toEqual(3)
        expect(channelLinks[0].textContent).toContain('Phillip Fry')
        expect(channelLinks[1].textContent).toContain('Turanga Leela')
        expect(channelLinks[2].textContent).toContain('Bender Rodriguez')
      })

      it('calls onChannelSelect with channel index when a channel link is clicked', () => {
        const channelLinks = TestUtils.scryRenderedDOMComponentsWithTag(view, 'a')
        TestUtils.Simulate.click(channelLinks[1])
        expect(onChannelSelectSpy).toHaveBeenCalledWith(1)
      })
    })

    describe('when there is data present', () => {
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
