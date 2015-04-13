import getJson from '../../web/static/js/get_json';
import {Promise} from 'es6-promise';

describe('getJson', function() {
  let xhr, requests;

  beforeEach(function() {
    requests = [];
    xhr = sinon.useFakeXMLHttpRequest();
    xhr.onCreate = function(req) {
      requests.push(req);
    };
  });

  afterEach(function() {
    xhr.restore();
  });

  it('returns a promise', function() {
    expect(getJson('foobar')).to.be.instanceOf(Promise);
  });

  it("requests the given URL as JSON", function() {
    getJson('foobar');
    expect(requests[0].url).to.eql('foobar');
    expect(requests[0].method).to.eql('GET');
    expect(requests[0].requestHeaders).to.have.property('Content-Type', 'application/json');
  });

  it("resolves with the parsed JSON body on success", function(done) {
    let promise = getJson("foobar");
    requests[0].respond(200, { "Content-Type": "application/json" }, '{ "foo": "bar" }');
    promise.then(function(result) {
      expect(result).to.eql({ "foo": "bar" });
      done();
    });
  });

  it("rejects with the response text on error", function(done) {
    let promise = getJson("foobar");
    requests[0].respond(404, { "Content-Type": "text/plain" }, "Not found");
    promise.catch(function(result) {
      expect(result.message).to.eql("Not found");
      done();
    });
  });
});
