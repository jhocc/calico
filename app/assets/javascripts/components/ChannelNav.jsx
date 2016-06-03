import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ChannelNav extends Component {
  render() {
    var divStyle = { background: 'white' }
    return (
      <ul className='channels' style={divStyle}>
        {
          this.props.data.map((channel, index) => {
            const user = channel.getIn(['channels_users', 0, 'user'])
            const firstName = user.get('first_name')
            const lastName = user.get('last_name')
            const onChannelSelect = () => { this.props.onChannelSelect(index) }
            return (
              <li>
                <a href='#' onClick={onChannelSelect}>
                  <img src='' alt='' />
                  <span>{firstName} {lastName}</span>
                </a>
              </li>
              )
            })
        }
      </ul>
    )
  }
}

ChannelNav.propTypes = {
  data: React.PropTypes.object,
  onChannelSelect: React.PropTypes.func,
}

ChannelNav.defaultProps = {
  data: Immutable.List(),
}
