import React, { Component } from 'react';
import Immutable from 'immutable';
import classNames from 'classnames';
import timeAgoInWords from '../utils/relative_date';

class Action extends Component {
  render() {
    const actionClasses = classNames({
      'action': true,
      'action--green': this.props.status === 'success',
      'action--red': this.props.status === 'error',
      'action--purple': this.props.status === 'deployed'
    });
    return (
      <div className={actionClasses}>{this.props.status}</div>
    );
  }
}

Action.PropTypes = {
  status: React.PropTypes.string.isRequired
};

export default class Event extends Component {
  render() {
    const event = this.props.event;
    const date = new Date(Date.parse(event.get('date')));
    return (
      <div className="event">
        <div className="event__title">{event.get('type')}</div>
        <h3 className="event__subject">{event.get('project').get('name')}</h3>
        <p className="event__description">{event.get('description')}</p>
        <Action status={event.get('status')} />
        <time className="event__date">{timeAgoInWords(date)}</time>
      </div>
    );
  }
}

Event.PropTypes = {
  event: React.PropTypes.instanceOf(Immutable.Map).isRequired
};
