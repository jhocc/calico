import * as Util from 'util/http'
import ChannelNav from 'components/ChannelNav'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class MessagePage extends Component {
  constructor() {
    super(...arguments)
    this.state = {
      channels: Immutable.List(),
    }
  }

  componentDidMount() {
    const xhr = Util.request('GET', '/messages.json', null)
    xhr.done((response) => {
      this.setState({ channels: Immutable.fromJS(response) })
    })
  }

  render() {
    const channelUsers = this.state.channels.map((channel) => (channel.get('channels_users'))).flatten(1)
    const otherChannelUsers = channelUsers.filter((channelUser) => (
      channelUser.get('user_id') !== this.props.currentUserId
    ))
    return (
      <div className='row dashboard'>
        <div className='col-md-3'>
          <ChannelNav data={otherChannelUsers}/>
        </div>
      </div>
    )
  }
}

MessagePage.propTypes = {
  currentUserId: React.PropTypes.number.isRequired,
}

