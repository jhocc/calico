import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ChannelNav extends Component {
  render() {
    var divStyle = { background: 'white' }
    return (
      <ul className='channels' style={divStyle}>
        {
          this.props.data.map((user) => {
            const firstName = user.getIn(['user','first_name'])
            const lastName = user.getIn(['user','last_name'])
            return (
              <li>
                <a href='#'>
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
}

ChannelNav.defaultProps = {
  data: Immutable.List(),
}
