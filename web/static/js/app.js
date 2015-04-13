import React from 'react';
import Wall from './components/wall';
import ProjectStore from './store';

React.render(
  React.createElement(Wall, { store: ProjectStore }),
  document.getElementById('page')
);
