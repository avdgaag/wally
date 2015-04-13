import React from "react";

export default class Badge extends React.Component {
  render() {
    return (
      <div className="badge">
        <div className="badge__value">{this.props.badge.value}</div>
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
