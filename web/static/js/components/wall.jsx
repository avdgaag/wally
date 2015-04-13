import React from 'react';
import Project from './project';

export default class Wall extends React.Component {
  constructor(props) {
    super(props);
    this.state = { projects: props.store.getProjects() };
    this.handleUpdates = this.handleUpdates.bind(this);
  }

  handleUpdates() {
    this.setState({ projects: this.props.store.getProjects() });
  }

  componentDidMount() {
    this.props.store.fetchProjects();
    this.props.store.observe(this.handleUpdates);
  }

  componentWillUnmount() {
    this.props.store.unobserve(this.handleUpdates);
  }

  renderProjects() {
    if(this.state.projects.length > 0) {
      return this.state.projects.map(function(project) {
        return (
          <Project key={project.title} project={project} />
        );
      });
    } else {
      return <div className="placeholder">There are no projects yet.</div>;
    }
  }

  render() {
    return (
      <div className="projects">
        {this.renderProjects()}
      </div>
    );
  }
}

Wall.propTypes = {
  store: React.PropTypes.object.isRequired
};
