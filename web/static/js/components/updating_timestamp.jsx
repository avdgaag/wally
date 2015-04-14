import React from "react";
import Timestamp from "../timestamp";

export default class UpdatingTimestamp extends React.Component {
  timeAgoInWords() {
    return new Timestamp(this.props.timestamp).inWords();
  }

  componentDidMount() {
    this.timer = setInterval(function() {
      this.forceUpdate();
    }.bind(this), this.props.interval);
  }

  componentWillUnmount() {
    clearInterval(this.timer);
    this.timer = null;
  }

  render() {
    return <span>{this.timeAgoInWords()}</span>
  }
}

UpdatingTimestamp.propTypes = {
  timestamp: React.PropTypes.string.isRequired,
  interval: React.PropTypes.number
};

UpdatingTimestamp.defaultProps = {
  interval: 1000
};
