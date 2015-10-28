import ProjectsList from '../../../web/static/js/components/projects_list';
import Project from '../../../web/static/js/components/project';

describe('ProjectsList', () => {
  it('show a Project component for each project', () => {
    const projects = Immutable.fromJS([
      { id: 1, title: 'My Project' },
      { id: 2, title: 'My other project' }
    ]);
    const output = renderComponent(<ProjectsList projects={projects} />);
    expect(output.type).to.eql('ol');
    expect(output).to.have.className('projects-list');
    const [project1, project2] = output.props.children;
    expect(project1.type).to.eql(Project);
    expect(project1.props.project.get('title')).to.eql('My Project');
    expect(project2.props.project.get('title')).to.eql('My other project');
  });
});
