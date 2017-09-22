import React from 'react'

const Views = {}
const Layouts = {}

class View extends React.Component {
  render() {
    var view = Views[this.props.view].call(this, this.props.data)
    var layout = Layouts[this.props.layout || 'Default']
    return layout(view)
  }
}

export {Views, Layouts, View}
