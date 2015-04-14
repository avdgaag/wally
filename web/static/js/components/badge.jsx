import React from "react";
import Timestamp from "../timestamp";
import UpdatingTimestamp from "./updating_timestamp";
import Checkmark from "./checkmark";

export default class Badge extends React.Component {
  renderValue() {
    let value = this.props.badge.value;
    if(Timestamp.matches(value)) {
      return <UpdatingTimestamp timestamp={value} />;
    } else if(Checkmark.matches(value)) {
      return <Checkmark status={value} />
    } else {
      return value;
    }
  }

  render() {
    return (
      <div className="badge">
        <div className="badge__value">{this.renderValue()}</div>
        <div className="badge__label">{this.props.badge.label}</div>
      </div>
    );
  }
}

Badge.propTypes = {
  badge: React.PropTypes.shape({
    label: React.PropTypes.string.isRequired,
    value: React.PropTypes.string.isRequired
  }).isRequired
};
