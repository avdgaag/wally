import chai from 'chai';

chai.Assertion.addMethod('className', function(cls) {
  let node = React.findDOMNode(this._obj);
  let className = node.className || '';
  let splitter = new RegExp(' +', 'g');
  let classes = className.toLowerCase().split(splitter);
  this.assert(
    className.indexOf(cls) > -1,
    "expected #{act} to include class #{exp}",
    "expected #{act} not to include class #{exp}",
    cls,
    className
  );
});

chai.Assertion.addMethod('innerHtml', function(str) {
  let node = React.findDOMNode(this._obj);
  this.assert(
    node.innerHTML.indexOf(str) > -1,
    "expected #{act} to include HTML #{exp}",
    "expected #{act} not to include HTML #{exp}",
    str,
    node.innerHTML
  );
});

chai.Assertion.addMethod('childComponent', function(options) {
  let components = TestUtils.findAllInRenderedTree(this._obj, function(component) {
    return (
      (!options.className || React.findDOMNode(component).className.split(' ').indexOf(options.className) >= 0) &&
      (!options.innerHtml || React.findDOMNode(component).innerHTML == options.innerHtml) &&
      (!options.type || TestUtils.isCompositeComponentWithType(component, options.type))
    );
  });
  this.assert(
    components.length == 1,
    "expected #{this} to have a child component matching #{exp}",
    "expected #{this} not to have a child component matching #{exp}",
    options,
    components
  );
});
