import reducer from '../../../web/static/js/reducers';

describe('Root reducer', () => {
  it('uses the projects and events reducers for projects', () => {
    const state = Immutable.fromJS({
      projects: Immutable.OrderedMap(),
      events: Immutable.OrderedMap()
    });
    expect(reducer(state)).to.have.sameValue(state);
  });
});
