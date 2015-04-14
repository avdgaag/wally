import React from "react";

let symbols = {
  "Passed": "✓",
  "Failed": "✗"
};
let matcher = new RegExp("^(" + Object.keys(symbols).join("|") + ")$", "i");

export default class Checkmark extends React.Component {
  symbolForStatus() {
    return symbols[this.props.status];
  }

  render() {
    return <span className="checkmark">{this.symbolForStatus()}</span>
  }
}

Checkmark.propTypes = {
  status: React.PropTypes.string.isRequired
};

Checkmark.matches = function(str) {
  return matcher.test(str);
};
