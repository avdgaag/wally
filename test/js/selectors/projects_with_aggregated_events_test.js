import { projectsWithAggregatedEvents } from '../../../web/static/js/utils/selectors';

describe('projectsWithaggregatedEvents', () => {
  let outputProject;

  beforeEach(() => {
    const date = new Date();
    const inputState = Immutable.fromJS({
      projects: {
        1: { id: 1, title: 'Project', eventIds: ['1', '2', '3'] }
      },
      events: {
        1: { id: 1, type: 'ci', status: 'success', subject: 'master', date: date },
        2: { id: 2, type: 'ci', status: 'failed', subject: 'feature', date: date + 10 },
        3: { id: 2, type: 'exception' }
      }
    });
    outputProject = projectsWithAggregatedEvents(inputState).get('1');
  });

  it('returns a map of projects similar to its input', () => {
    const inputState = Immutable.fromJS({
      projects: {
        1: { id: 1, title: 'Project', eventIds: [] }
      },
      events: {}
    });
    const outputState = Immutable.fromJS({
      '1': {
        id: 1,
        title: 'Project',
        eventIds: [],
        events: [],
        masterBuildStatus: undefined,
        lastBuildStatus: undefined,
        recentExceptionsCount: 0
      }
    });
    expect(projectsWithAggregatedEvents(inputState)).to.have.sameValue(outputState);
  });

  it('calculates a masterBuildStatus from ci events', () => {
    expect(outputProject.get('masterBuildStatus')).to.eql(true);
  });

  it('calculates a lastBuildStatus from ci events', () => {
    expect(outputProject.get('lastBuildStatus')).to.eql(false);
  });

  it('calculates a recentExceptionsCount from exception events', () => {
    expect(outputProject.get('recentExceptionsCount')).to.eql(1);
  });
});
