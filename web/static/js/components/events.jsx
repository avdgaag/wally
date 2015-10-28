import React, { Component } from 'react';
import Immutable from 'immutable';
import Event from './event';

export default class Events extends Component {
  renderTypes() {
    return this.props.events.toList().map(event => <Event key={event.get('id')} event={event} />);
  }

  render() {
    return (
      <div className="events">
        {this.renderTypes()}
      </div>
    );
  }
}

Events.PropTypes = {
  events: React.PropTypes.instanceOf(Immutable.List)
};
