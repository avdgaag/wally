import './bind_polyfill';
import React from 'react';
import Wall from './components/wall';
import ProjectStore from './store';
import observeNotifications from './notifications';

observeNotifications(function(badge) {
  ProjectStore.updateBadge(badge);
});

React.render(
  React.createElement(Wall, { store: ProjectStore }),
  document.getElementById('page')
);
