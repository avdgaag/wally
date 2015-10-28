import React, { Component } from 'react';
import Immutable from 'immutable';
import Badge from './badge';

/*
 * A single project in the listing of all projects on the status wall.
 */
export default class Project extends Component {
  render() {
    const project = this.props.project;
    return (
        <li className="project">
          <Badge icon="primitive-dot" status={project.get('masterBuildStatus')} />
          <Badge icon="git-branch" status={project.get('lastBuildStatus')} />
          <span className="project__title">
            {project.get('name')}
          </span>
          <Badge icon="bug" status={project.get('recentExceptionsCount') === 0}>
            {project.get('recentExceptionsCount')}
          </Badge>
        </li>
    );
  }
};

Project.propTypes = {
  project: React.PropTypes.instanceOf(Immutable.Map).isRequired
};
