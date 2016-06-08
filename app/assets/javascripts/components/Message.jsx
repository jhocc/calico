import React, { Component, DOM } from 'react'

export default class Message extends Component {
  render() {
    return (
      <div className='message'>
        <div className='profile-picture'>
          <img src={this.props.profileUrl} alt={this.props.username} />
        </div>
        <div className='message-body'>
          <span className='username'>{this.props.username}</span>
          <span className='date'>{this.props.createdAt}</span><br/>
          {this.props.children}
        </div>
      </div>
    )
  }
}

Message.propTypes = {
  profileUrl: React.PropTypes.string.isRequired,
  username: React.PropTypes.string.isRequired,
  createdAt: React.PropTypes.string.isRequired
}

