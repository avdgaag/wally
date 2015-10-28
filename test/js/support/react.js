import React from 'react/addons';
global.React = React;
global.TestUtils = React.addons.TestUtils;
global.renderComponent = (element) => {
  const renderer = TestUtils.createRenderer();
  renderer.render(element);
  return renderer.getRenderOutput();
};
