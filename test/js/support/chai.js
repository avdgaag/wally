import chai from 'chai';
import sinon from 'sinon';
import sinonChai from 'sinon-chai';
chai.config.includeStack = true;
chai.use(sinonChai);

global.expect = chai.expect;
global.sinon = sinon;
global.sandbox = null;
