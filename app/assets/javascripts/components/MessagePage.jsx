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
    const channelUsers = channels.map((channel) => (channel.get('channels_users'))).flatten(1)
    const otherChannelUsers = channelUsers.filter((channelUser) => (
      channelUser.get('user_id') !== currentUserId
    ))
    return otherChannelUsers
  }

  conversationHeader(currentChannelUser) {
    if (currentChannelUser) {
      const firstName = currentChannelUser.getIn(['user','first_name'])
      const lastName = currentChannelUser.getIn(['user','last_name'])
      return (
        <h2 className='conversation-header'>
          Conversation with <strong>{firstName} {lastName}</strong>
        </h2>
      )
    }
  }

  render() {
    const currentChannelUser = this.state.channels.get(this.state.activeChannel)
    return (
      <div className='row dashboard'>
        <div className='col-md-3'>
          <ChannelNav data={this.state.channels}/>
        </div>
        <div className='col-md-9'>{this.conversationHeader(currentChannelUser)}</div>
      </div>
    )
  }
}

MessagePage.propTypes = {
  currentUserId: React.PropTypes.number.isRequired,
}

