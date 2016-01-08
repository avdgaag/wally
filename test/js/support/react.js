import React from 'react';
import TestUtils from 'react-addons-test-utils';
global.React = React;
global.TestUtils = TestUtils;
global.renderComponent = (element) => {
  const renderer = TestUtils.createRenderer();
  renderer.render(element);
  return renderer.getRenderOutput();
};
