import * as Util from 'util/http'
import ChannelNav from 'components/ChannelNav'
import ConversationHeader from 'components/ConversationHeader'
import ConversationHistory from 'components/ConversationHistory'
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
    this.loadChannels = this.loadChannels.bind(this)
    this.send = this.send.bind(this)
    this.mark = this.mark.bind(this)
  }

  componentDidMount() {
    this.loadChannels()
    this.interval = setInterval(this.loadChannels, 2000);
  }

  componentWillUnmount() {
    clearInterval(this.interval)
  }

  loadChannels() {
    const xhr = Util.request('GET', '/channels.json', null)
    xhr.done((response) => {
      this.setState({
        channels: Immutable.fromJS(response)
      })
    })
  }

  send() {
    Util.request(
      'POST',
      `/channels/${this.getActiveChannelId()}/messages.json`,
      { message: { content: this.refs.messageInput.value } }
    ).done((_) => {
      this.loadChannels()
    })
    this.refs.messageInput.value = ''
  }

  mark() {
    Util.request(
      'PUT',
      `/channels/${this.getActiveChannelId()}/mark.json`,
      { channel_id: this.getActiveChannelId() }
    ).done((_) => {
      this.loadChannels()
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

  getActiveChannelId() {
    return this.state.channels.getIn([this.state.activeChannel, 'id'])
  }

  setActiveChannel(index) {
    this.setState({
      activeChannel: index
    })
    this.mark()
  }

  render() {
    const filteredChannels = this.filterUserChannelsOfCurrent(
      this.state.channels,
      this.props.currentUserId
    )
    const currentChannel = filteredChannels.get(this.state.activeChannel)
    return (
      <div className='row dashboard'>
        <div className='col-md-3'>
          <ChannelNav
            data={this.state.channels}
            onChannelSelect={this.setActiveChannel}
            activeIndex={this.state.activeChannel}
            currentUserId={this.props.currentUserId}
          />
        </div>
        <div className='col-md-9'>
          <ConversationHeader channel={currentChannel} />
          <ConversationHistory channel={currentChannel} />
          <div className='message-input'>
            <div className='profile-picture'>
              <img src=''/>
            </div>
            <div className='message-box'>
              <textarea autoFocus ref='messageInput' name='message-input' placeholder='Type your message here...'></textarea>
            </div>
            <div className='actions'>
              <input
                type='submit'
                onClick={this.send}
                value='Send'
                className='btn btn-lg btn-primary btn-block btn-success'
              />
            </div>
          </div>
        </div>
      </div>
    )
  }
}

MessagePage.propTypes = {
  currentUserId: React.PropTypes.number.isRequired,
}

