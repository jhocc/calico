import Immutable from 'immutable'
import React, { Component, DOM } from 'react'

export default class ChannelNav extends Component {
  render() {
    var divStyle = { background: 'white' }
    return (
      <ul className='nav media-list' style={divStyle}>
        {
          this.props.data.map((user) => {
            const firstName = user.getIn(['user','first_name'])
            const lastName = user.getIn(['user','last_name'])
            return (
              <li className='media'>
                <a href='#'>
                  <div className='media-left'>
                    <img className='media-object' src='' alt='' />
                  </div>
                  <div className='media-body'>
                    <div className='media-heading'>{firstName} {lastName}</div>
                  </div>
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
