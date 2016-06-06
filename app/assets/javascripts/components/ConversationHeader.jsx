import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ConversationHeader extends Component {
  render() {
    if (this.props.channel) {
      const user = this.props.channel.getIn(['channels_users', 0, 'user'])
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
  channel: React.PropTypes.object.isRequired,
}

