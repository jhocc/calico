import {Views} from '../components/view'
import React from 'react'
import ChannelNav from '../components/channel_nav'
import ConversationHeader from '../components/conversation_header'
import ConversationHistory from '../components/conversation_history'

Views.ChannelzShow = (json) => {
  return (
    <div className='row dashboard'>
      <div className='col-md-3'>
        <div>
        <ChannelNav data={json.channels} />
      </div>

      </div>
      <div className='col-md-9'>
        <ConversationHeader
          name={json.header}
        />
        <ConversationHistory messages={json.messages}/>
        <form className='message-input' action={json.channelz_message_path} method='post'>
          <div className='profile-picture'>
            <img className='my-profile-picture' src={json.badge} />
          </div>
          <div className='message-box'>
            <textarea autoFocus ref='messageInput' name='message[content]' placeholder='Type your message here...'></textarea>
            <input
              type='hidden'
              name='authenticity_token'
              value={json.csrf_token}
            />
          </div>
          <div className='actions'>
            <input
              type='submit'
              value='Send'
              className='btn btn-lg btn-primary btn-block'
            />
          </div>
        </form>
      </div>
    </div>
  )
}
