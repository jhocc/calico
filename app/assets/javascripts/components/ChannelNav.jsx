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
                  this.props.data.map((channel, index) => {
                    const user = channel.getIn(['channels_users', 0, 'user'])
                    const firstName = user.get('first_name')
                    const lastName = user.get('last_name')
                    const onChannelSelect = () => { this.props.onChannelSelect(index) }
                    const isActive = (index === this.props.activeIndex)
                    return (
                      <li key={`channel_${channel.get('id')}`} className={isActive ? 'active' : ''}>
                        <a href='#' onClick={onChannelSelect}>
                          <img src='' alt='' />
                          <span>{firstName} {lastName}</span>
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

ChannelNav.propTypes = {
  data: React.PropTypes.object,
  onChannelSelect: React.PropTypes.func,
  activeIndex: React.PropTypes.number,
}

ChannelNav.defaultProps = {
  data: Immutable.List(),
}
