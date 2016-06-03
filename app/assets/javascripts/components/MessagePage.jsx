import * as Util from 'util/http'
import ChannelNav from 'components/ChannelNav'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'
import moment from 'moment'

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
    let messages
    if (currentChannel) {
      messages = currentChannel.get('messages').map((msg) => {
        const fullName = `${msg.getIn(['user', 'first_name'])} ${msg.getIn(['user', 'last_name'])}`
        const createdAt = moment(msg.get('created_at')).format('M/D, h:mm a')
        return (
          <div className='message'>
            <div className='profile-picture'>
              <img src=''/>
            </div>
            <div className='message-body'>
              <span className='username'>{fullName}</span>
              <span className='date'>{createdAt}</span><br/>
              <p>{msg.get('content')}</p>
            </div>
          </div>
        )
      })
    }
    return (
      <div className='row dashboard'>
        <div className='col-md-3'>
          <ChannelNav data={this.state.channels} onChannelSelect={this.setActiveChannel}/>
        </div>
        <div className='col-md-9'>
          {this.conversationHeader(currentChannel)}
          <div className='message-window' style={{background: 'white'}}>
            {messages}
          </div>
        </div>
      </div>
    )
  }
}

MessagePage.propTypes = {
  currentUserId: React.PropTypes.number.isRequired,
}

