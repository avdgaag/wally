import React, { Component } from 'react';
import classNames from 'classnames';

export default class Badge extends Component {
  render() {
    const classes = {
      'badge': true,
      'badge--green': this.props.status,
      'badge--red': typeof this.props.status !== 'undefined' && ! this.props.status,
      'badge--gray': typeof this.props.status === 'undefined'
    };
    return (
      <span className={classNames(classes)}>
        {this.props.children}
        <i className={"mega-octicon octicon-" + this.props.icon} />
      </span>
    );
  }
}

Badge.PropTypes = {
  status: React.PropTypes.bool.isRequired,
  icon: React.PropTypes.string.isRequired
};
