import * as ChannelUtil from 'util/channels'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ConversationHeader extends Component {
  render() {
    if (this.props.channel) {
      const [_, otherChannelUser] = ChannelUtil.userAndOther(this.props.channel, this.props.currentUserId)
      const user = otherChannelUser.get('user')
      const firstName = user.get('first_name')
      const lastName = user.get('last_name')
      return (
        <h2 style={{marginBottom: '20px'}} className='conversation-header'>
          Conversation with <strong>{firstName} {lastName}</strong>
        </h2>
      )
    } else {
      return null
    }
  }
}

ConversationHeader.propTypes = {
  channel: React.PropTypes.object,
  currentUserId: React.PropTypes.number.isRequired,
}

