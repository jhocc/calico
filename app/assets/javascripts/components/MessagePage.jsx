import * as Util from 'util/http'
import * as ChannelUtil from 'util/channels'
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
      activeChannel: this.props.activeChannel
    }
    this.setActiveChannel = this.setActiveChannel.bind(this)
    this.loadChannels = this.loadChannels.bind(this)
    this.send = this.send.bind(this)
    this.mark = this.mark.bind(this)
  }

  componentDidMount() {
    this.loadChannels()
    this.interval = setInterval(this.loadChannels, 2000);
    this.interval = setInterval(this.mark, 2000);
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
    const activeChannel = this.getActiveChannelId()
    if (activeChannel) {
      Util.request(
        'PUT',
        `/channels/${activeChannel}/mark.json`,
        { channel_id: activeChannel }
      )
    }
  }

  getActiveChannelId() {
    return this.state.activeChannel
  }

  setActiveChannel(channelId) {
    this.setState({
      activeChannel: channelId
    })
    this.mark()
  }

  render() {
    const currentChannel = this.state.channels.find((channel) => (channel.get('id') === this.state.activeChannel))
    var channelUserProfile
    if (currentChannel) {
      const [channelUser, _] = ChannelUtil.userAndOther(currentChannel, this.props.currentUserId)
      channelUserProfile = channelUser.getIn(['user', 'profile_photo', 'small', 'url'])
    }
    return (
      <div className='row dashboard'>
        <div className='col-md-3'>
          <ChannelNav
            data={this.state.channels}
            onChannelSelect={this.setActiveChannel}
            activeChannel={this.state.activeChannel}
            currentUserId={this.props.currentUserId}
          />
        </div>
        <div className='col-md-9'>
          <ConversationHeader channel={currentChannel} currentUserId={this.props.currentUserId} />
          <ConversationHistory channel={currentChannel} currentUserId={this.props.currentUserId} />
          <div className='message-input'>
            <div className='profile-picture'>
              <img className='my-profile-picture' src={channelUserProfile} />
            </div>
            <div className='message-box'>
              <textarea autoFocus ref='messageInput' name='message-input' placeholder='Type your message here...'></textarea>
            </div>
            <div className='actions'>
              <input
                type='submit'
                onClick={this.send}
                value='Send'
                className='btn btn-lg btn-primary btn-block'
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
  activeChannel: React.PropTypes.number,
}

