import Store from '../../web/static/js/store';

describe('Store', function() {
  let requests;
  let xhr;

  beforeEach(function() {
    xhr = sinon.useFakeXMLHttpRequest();
    requests = [];
    xhr.onCreate = req => requests.push(req);
  });

  afterEach(function() {
    xhr.restore();
  });

  it("has no projects by default", function() {
    expect(Store.getProjects()).to.be.empty;
  });

  it("can add an observer", function(done) {
    let spy = sandbox.spy()
    Store.observe(spy);
    let promise = Store.fetchProjects();
    expect(requests).to.have.length(1);
    requests[0].respond(200, {}, '{}');
    promise.then(function() {
      expect(spy).to.have.been.called;
      done();
    });
  });

  it("can remove an observer", function() {
    let spy = sandbox.spy()
    Store.observe(spy);
    Store.fetchProjects();
    Store.unobserve(spy);
    requests[0].respond(200, {}, '{}');
    expect(spy).not.to.have.been.called;
  });

  it("can fetch projects from the API", function() {
    Store.fetchProjects();
    expect(requests[0].url).to.eql("/wall");
    expect(requests[0].method).to.eql("GET");
    expect(requests[0].requestHeaders).to.eql({ "Content-Type": "application/json" });
  });

  it("updates projects by parsing the API response as JSON", function(done) {
    let projects = [{ "foo": "bar" }];
    expect(Store.getProjects()).not.to.eql(projects);
    let promise = Store.fetchProjects()
    requests[0].respond(200, {}, JSON.stringify(projects));
    promise.then(function() {
      expect(Store.getProjects()).to.eql(projects);
      done();
    });
  });

  it("adds a new badge to a project", function(done) {
    let projects = [{ id: 1, title: "First project", badges: [] }];
    let promise = Store.fetchProjects();
    requests[0].respond(200, {}, JSON.stringify(projects));
    promise.then(function() {
      Store.updateBadge({ id: 5, label: "CI", value: "Passing", project_id: 1 });
      expect(Store.getProjects()[0].badges).to.have.length(1);
      done();
    });
  });

  it("updates an existing badge in a project", function(done) {
    let projects = [{ id: 1, title: "First project", badges: [{ id: 5, label: "CI", value: "Failed" }] }];
    let promise = Store.fetchProjects();
    requests[0].respond(200, {}, JSON.stringify(projects));
    promise.then(function() {
      Store.updateBadge({ id: 5, label: "CI", value: "Passing", project_id: 1 });
      let projects = Store.getProjects();
      expect(projects[0].badges[0].value).to.eql("Passing");
      done();
    });
  });
});
