import React, { Component, DOM } from 'react'

export default class ConversationHeader extends Component {
  render() {
    return (
      <h2 style={{marginBottom: '20px'}} className='conversation-header'>
        Conversation with <strong>{this.props.name}</strong>
      </h2>
    )
  }
}
