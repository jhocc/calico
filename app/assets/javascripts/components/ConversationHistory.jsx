import Immutable from 'immutable'
import React, { Component, DOM } from 'react'
import moment from 'moment'

export default class ConversationHistory extends Component {
  render() {
    let messages
    if (this.props.channel) {
      messages = this.props.channel.get('messages').map((msg) => {
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
      <div className='message-window' style={{background: 'white'}}>
        {messages}
      </div>
    )
  }
}

ConversationHistory.propTypes = {
  channel: React.PropTypes.object.isRequired,
}

