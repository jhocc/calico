import * as Util from 'util/channels'
import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ChannelNav extends Component {
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
              return (
                <li key={`channel_${channel.id}`}>
                  <a href={channel.url}>
                    <img src={channel.photo}/>
                    <span>{channel.name}</span>
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
