import Immutable from 'immutable';
const emptyState = Immutable.OrderedMap();

export default function(state = emptyState, action = {}) {
  switch(action.type) {
  case 'NEW_EVENT':
    const event = action.event;
    if(!state.has(event.projectId)) {
      return state;
    }
    return state.updateIn(
      [event.projectId, 'eventIds'],
      arr => arr.push(event.id)
    );
  case 'ADD_PROJECT':
  case 'UPDATE_PROJECT':
    return state.set(action.project.get('id'), action.project);
  case 'REMOVE_PROJECT':
    return state.delete(action.project.get('id'));
  default:
    return state;
  }
}
