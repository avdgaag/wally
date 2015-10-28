import React, { Component } from 'react';
import { connect } from 'react-redux';
import ProjectsList from '../components/projects_list';
import Events from '../components/events';
import { mainSelector } from '../utils/selectors';
import { List } from 'immutable';

/*
 * Top-level component for the Wally application, connected to the
 * `projects` key in the application state tree.
 */
class Wally extends Component {
  render() {
    return (
      <div className="wally">
        <ProjectsList projects={this.props.data.get('projects')} />
        <Events events={this.props.data.get('events')} />
      </div>
    );
  }
};

Wally.propTypes = {
  data: React.PropTypes.object.isRequired
};

export default connect(state => { return { data: mainSelector(state) } })(Wally);
