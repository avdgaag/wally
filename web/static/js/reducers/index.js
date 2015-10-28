import projects from './projects';
import events from './events';
import Immutable from 'immutable';

const emptyState = Immutable.Map();

/*
 * Construct a custom root reducer instead of using redux's combineReducers
 * since that function expects simple Javascript objects rather than Immutable's
 * Map.
 */
export default function reducer(state = emptyState, action) {
  let newState = state;
  newState = newState.set('projects', projects(newState.get('projects'), action));
  newState = newState.set('events', events(newState.get('events'), action));
  return newState;
}
