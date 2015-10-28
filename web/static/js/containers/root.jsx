import React, { Component } from 'react';
import { createStore } from 'redux';
import { Provider } from 'react-redux';
import Wally from './wally';
import reducer from '../reducers';
import Immutable from 'immutable';
import socket from '../socket';

const store = createStore(reducer, Immutable.fromJS(window.__initialState__));
window.store = store;

const channel = socket.channel('actions', {});
channel.on('event:new', resp => store.dispatch(resp));
channel.join()
  .receive('ok', resp => console.log('Joined succesfully', resp))
  .receive('error', resp => console.log('Unable to join', resp));

export default class Root extends Component {
  render() {
    return (
      <Provider store={store}>
        <Wally />
      </Provider>
    );
  }
}
