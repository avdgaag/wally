import React from 'react';

export default class Project extends React.Component {
  render() {
    return (
      <div className="project">
        <div className="project__title">{this.props.project.title}</div>
      </div>
    );
  }
}

Project.propTypes = {
  project: React.PropTypes.shape({
    title: React.PropTypes.string.isRequired,
  }).isRequired
};
