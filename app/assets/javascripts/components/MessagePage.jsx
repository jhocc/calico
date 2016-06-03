import * as Util from 'util/http'
import ChannelNav from 'components/ChannelNav'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class MessagePage extends Component {
  constructor() {
    super(...arguments)
    this.state = {
      channels: Immutable.List(),
      activeChannel: 0,
    }
    this.setActiveChannel = this.setActiveChannel.bind(this)
  }

  componentDidMount() {
    const xhr = Util.request('GET', '/messages.json', null)
    xhr.done((response) => {
      this.setState({
        channels: this.filterUserChannelsOfCurrent(Immutable.fromJS(response), this.props.currentUserId)
      })
    })
  }

  filterUserChannelsOfCurrent(channels, currentUserId) {
    return channels.map((channel) => {
      const otherChannelUsers = channel.get('channels_users').filter((channelUser) => (
        channelUser.get('user_id') !== currentUserId
      ))
      return channel.set('channels_users', otherChannelUsers)
    })
  }

  conversationHeader(currentChannel) {
    if (currentChannel) {
      const user = currentChannel.getIn(['channels_users', 0, 'user'])
      const firstName = user.get('first_name')
      const lastName = user.get('last_name')
      return (
        <h2 className='conversation-header'>
          Conversation with <strong>{firstName} {lastName}</strong>
        </h2>
      )
    }
  }

  setActiveChannel(index) {
    this.setState({
      activeChannel: index
    })
  }

  render() {
    const currentChannel = this.state.channels.get(this.state.activeChannel)
    return (
      <div className='row dashboard'>
        <div className='col-md-3'>
          <ChannelNav data={this.state.channels} onChannelSelect={this.setActiveChannel}/>
        </div>
        <div className='col-md-9'>{this.conversationHeader(currentChannel)}</div>
      </div>
    )
  }
}

MessagePage.propTypes = {
  currentUserId: React.PropTypes.number.isRequired,
}

