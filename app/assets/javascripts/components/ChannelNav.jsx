import * as Util from 'util/channels'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ChannelNav extends Component {
  lastMessageCreatedAt(messages) {
    if (messages && !messages.isEmpty()) {
      const sortedMessages = messages.sort((messageA, messageB) => {
        return messageA.get('id') < messageB.get('id')
      })
      return sortedMessages.first().get('created_at')
    } else {
      return null
    }
  }

  channelClass(readAt, lastMessageCreatedAt) {
    if (!lastMessageCreatedAt) {
      return 'read'
    } else if (!readAt) {
      return 'unread'
    } else if (readAt >= lastMessageCreatedAt) {
      return 'read'
    } else {
      return 'unread'
    }
  }

  render() {
    var divStyle = { background: 'white' }
    return (
      <div>
        <div className="sidebar-header"><i className="fa fa-comments" aria-hidden="true"></i>
          My Conversations
        </div>
        <ul className='channels' style={divStyle}>
          {
            this.props.data.map((channel) => {
              const channelId = channel.get('id')
              const [channelUser, otherChannelUser] = Util.userAndOther(channel, this.props.currentUserId)
              let className = ''
              const isActive = (channelId === this.props.activeChannel)
              if (isActive) {
                className = 'active'
              } else {
                const lastCreatedAt = this.lastMessageCreatedAt(channel.get('messages'))
                className = this.channelClass(channelUser.get('read_at'), lastCreatedAt)
              }
              const fullName = `${otherChannelUser.getIn(['user', 'first_name'])} ${otherChannelUser.getIn(['user', 'last_name'])}`
              const onChannelSelect = () => { this.props.onChannelSelect(channelId) }
              return (
                <li key={`channel_${channelId}`} className={className}>
                  <a href='#' onClick={onChannelSelect}>
                    <img src={otherChannelUser.getIn(['user', 'profile_photo', 'small', 'url'])} alt={fullName} />
                    <span>{fullName}</span>
                  </a>
                </li>
                )
            })
          }
        </ul>
      </div>
    )
  }
}

ChannelNav.propTypes = {
  data: React.PropTypes.object,
  onChannelSelect: React.PropTypes.func,
  activeChannel: React.PropTypes.number,
  currentUserId: React.PropTypes.number,
}

ChannelNav.defaultProps = {
  data: Immutable.List(),
}
