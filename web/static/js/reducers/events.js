import Immutable from 'immutable';
const initialState = Immutable.OrderedMap();

export default function(state = initialState, action) {
  if(typeof action === 'undefined') {
    return state;
  }

  switch(action.type) {
  case 'NEW_EVENT':
    const event = Immutable.fromJS(action.event);
    return state.set(action.event.id, event);
  default:
    return state;
  }
}
