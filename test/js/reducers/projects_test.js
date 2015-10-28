import projects from '../../../web/static/js/reducers/projects';

describe('Projects reducer', () => {
  it('returns the same state as was passed in', () => {
    const state = Immutable.fromJS([{ foo: 'bar' }]);
    expect(projects(state)).to.eql(state);
  });

  it('returns a default empty OrderedMap of projects when given no state', () => {
    expect(projects()).to.eql(Immutable.OrderedMap());
  });

  it('can add a project to the state', () => {
    const state = Immutable.OrderedMap();
    const newState = state.set(1, Immutable.Map({ id: 1, title: 'Title' }));
    const action = {
      type: 'ADD_PROJECT',
      project: Immutable.Map({ id: 1, title: 'Title' })
    };
    expect(projects(state, action)).to.eql(newState);
  });

  it('removes a project from the state', () => {
    const state = Immutable.OrderedMap({ 1: Immutable.Map({ id: 1, title: 'Title' })});
    const newState = state.delete(0);
    const action = {
      type: 'REMOVE_PROJECT',
      project: Immutable.Map({ id: 1, title: 'Title' })
    };
    expect(projects(state, action)).to.have.sameValue(newState);
  });

  it('can update a project', () => {
    const state = Immutable.OrderedMap({ 1: Immutable.Map({ id: 1, title: 'Title' })});
    const newProject = Immutable.Map({ id: 1, title: 'New Title' });
    const newState = state.set(1, newProject);
    const action = {
      type: 'UPDATE_PROJECT',
      project: newProject
    };
    expect(projects(state, action)).to.have.sameValue(newState);
  });
});
