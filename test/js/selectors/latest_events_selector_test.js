import { latestEventsSelector } from '../../../web/static/js/utils/selectors';

describe('latestEventsSelector', () => {
  it('returns a map of event categories and their latest events', () => {
    const event1 = Immutable.Map({ type: 'deployment', projectId: 1, date: new Date(2015, 3, 1) });
    const event2 = Immutable.Map({ type: 'ci', projectId: 1, date: new Date(2015, 3, 1) });
    const event3 = Immutable.Map({ type: 'deployment', projectId: 1, date: new Date(2015, 4, 1) });
    const project = Immutable.Map({ id: 1, title: 'Project' });
    const inputState = Immutable.fromJS({ projects: { 1: project }, events: { 1: event1, 2: event2, 3: event3 }});
    const outputState = Immutable.Map({ deployment: event3.set('project', project), ci: event2.set('project', project) });
    expect(latestEventsSelector(inputState)).to.have.sameValue(outputState);
  });
});
