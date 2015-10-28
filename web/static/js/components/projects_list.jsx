import React from 'react';
import Project from './project';
import Immutable from 'immutable';
import Placeholder from '../components/placeholder';

/*
 * The list of projects on the status wall, showing a single a Project
 * component for each entry in the `projects` prop.
 */
export default class ProjectsList extends React.Component {
  renderProjects() {
    return this.props.projects.toList().map(project => <Project key={project.get('id')} project={project} />);
  }

  render() {
    if(this.props.projects.size > 0) {
      return <ol className="projects-list">{this.renderProjects()}</ol>;
    } else {
      return <Placeholder />;
    }
  }
};

ProjectsList.propTypes = {
  projects: React.PropTypes.instanceOf(Immutable.Iterable).isRequired
};
