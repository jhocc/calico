import * as ChannelUtil from 'util/channels'
import Immutable from 'immutable'
import Message from 'components/Message'
import React, { Component, DOM } from 'react'
import moment from 'moment'

export default class ConversationHistory extends Component {
  componentDidUpdate(prevProps, prevState) {
    this.refs.messageWindow.scrollTop = this.refs.messageWindow.scrollHeight
  }

  render() {
    let messages = this.props.messages.map((msg) => {
      const name = msg.name
      const createdAt = moment(msg.created_at).format('M/D, h:mm a')
      const profileUrl = msg.profile_photo_url
      return (
        <Message key={`message_${msg.id}`} profileUrl={profileUrl} username={name} createdAt={createdAt} >
          <p>{msg.content}</p>
        </Message>
      )
    })

    return (
      <div ref='messageWindow' className='message-window' style={{background: 'white'}}>
        {messages}
        <div className='mobile-spacer'></div>
      </div>
    )
  }
}
