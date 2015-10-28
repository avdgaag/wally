import Project from '../../../web/static/js/components/project';
import Badge from '../../../web/static/js/components/badge';

describe('Project', () => {
  let project;
  let output;

  beforeEach(() => {
    project = Immutable.Map({
      id: 1,
      recentExceptionsCount: 3,
      name: 'Project title',
      masterBuildStatus: true,
      lastBuildStatus: true
    });
    output = renderComponent(<Project project={project} />);
  });

  it('show the project title in a list item', () => {
    const title = output.props.children[2];
    expect(title.type).to.eql('span');
    expect(title.props.children).to.eql('Project title');
    expect(title).to.have.className('project__title');
  });

  it('shows a badge for the master build status', () => {
    const badge = output.props.children[0];
    expect(badge.type).to.eql(Badge);
    expect(badge.props.icon).to.eql('primitive-dot');
    expect(badge.props.status).to.be.ok;
  });

  it('shows a badge for the latest build status', () => {
    const badge = output.props.children[1];
    expect(badge.type).to.eql(Badge);
    expect(badge.props.icon).to.eql('git-branch');
    expect(badge.props.status).to.be.ok;
  });

  it('shows a badge for the number of exceptions', () => {
    const badge = output.props.children[3];
    expect(badge.type).to.eql(Badge);
    expect(badge.props.icon).to.eql('bug');
    expect(badge.props.children).to.eql(3);
  });
});
