import React from 'react';
import Badge from './badge';

export default class Project extends React.Component {
  renderBadges() {
    return this.props.project.badges.map(badge => {
      return <Badge key={badge.label} badge={badge} />;
    })
  }

  render() {
    return (
      <div className="project">
        <div className="project__title">{this.props.project.title}</div>
        {this.renderBadges()}
      </div>
    );
  }
}

Project.propTypes = {
  project: React.PropTypes.shape({
    title: React.PropTypes.string.isRequired,
    badges: React.PropTypes.array.isRequired
  }).isRequired
};
