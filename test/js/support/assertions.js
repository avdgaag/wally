import chai from 'chai';

chai.Assertion.addMethod('sameValue', function(value) {
  this.assert(
    Immutable.is(this._obj, value),
    'expected #{act} to have the same value as #{exp}',
    'expected #{act} not to have the same value as #{exp}',
    this._obj.toJS(),
    value.toJS()
  );
});

chai.Assertion.addMethod('className', function(cls) {
  const className = this._obj.props.className || '';
  const splitter = new RegExp(' +', 'g');
  const classes = className.toLowerCase().split(splitter);
  this.assert(
    classes.indexOf(cls) > -1,
    'expected className #{act} to include class #{exp}',
    'expected className #{act} not to include class #{exp}',
    cls,
    className
  );
});
