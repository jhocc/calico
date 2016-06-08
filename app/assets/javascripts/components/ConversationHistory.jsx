import * as ChannelUtil from 'util/channels'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'
import moment from 'moment'

export default class ConversationHistory extends Component {
  shouldComponentUpdate(nextProps, _) {
    if (!this.props.channel) { return true }

    const messages = this.props.channel.get('messages')
    const nextMessages =  nextProps.channel.get('messages')
    return !messages.equals(nextMessages)
  }

  componentDidUpdate(prevProps, prevState) {
    this.refs.messageWindow.scrollTop = this.refs.messageWindow.scrollHeight
  }

  welcomeMessage() {
    const channel = this.props.channel
    if (channel) {
      const [_, otherChannelUser] = ChannelUtil.userAndOther(this.props.channel, this.props.currentUserId)
      const user = otherChannelUser.get('user')
      if (user.get('email') === 'calico_feedback_user@casecommons.org') {
        const fullName = `${user.get('first_name')} ${user.get('last_name')}`
        const createdAt = moment(channel.get('created_at')).format('M/D, h:mm a')
        return (
          <div className='message'>
            <div className='profile-picture'>
              <img src=''/>
            </div>
            <div className='message-body'>
              <span className='username'>{fullName}</span>
              <span className='date'>{createdAt}</span><br/>
              <p>Hi there!<br /><br />
                Welcome to Calico, a messaging app for caseworkers, birth and foster parents,
                designed to help coordinate and communicate. <br /><br />
                To get started, click on the menu button (<i className='fa fa-bars' aria-hidden='true'></i>) and go to the <a href='/foster_family_agencies'>Resource Finder</a> (<i className='fa fa-crosshairs' aria-hidden='true'></i>).
                This will put you in touch with foster family agencies in your area.
                From there, select a resource and you will see a list of caseworkers that you can message.<br /><br />
                Next time you login, you will see all conversations with caseworkers on your home page so you can message there.</p>
            </div>
          </div>
        )
      }
    }
  }

  render() {
    let messages
    if (this.props.channel) {
      messages = this.props.channel.get('messages').map((msg) => {
        const fullName = `${msg.getIn(['user', 'first_name'])} ${msg.getIn(['user', 'last_name'])}`
        const createdAt = moment(msg.get('created_at')).format('M/D, h:mm a')
        return (
          <div key={`message_${msg.get('id')}`} className='message'>
            <div className='profile-picture'>
              <img src={msg.getIn(['user', 'profile_photo', 'small', 'url'])} alt={fullName} />
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
      <div ref='messageWindow' className='message-window' style={{background: 'white'}}>
        {this.welcomeMessage()}
        {messages}
        <div className='mobile-spacer'></div>
      </div>
    )
  }
}

ConversationHistory.propTypes = {
  channel: React.PropTypes.object.isRequired,
  currentUserId: React.PropTypes.number.isRequired,
}

