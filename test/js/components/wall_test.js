import Wall from "../../../web/static/js/components/wall";
import Project from "../../../web/static/js/components/project";

describe("Wall", function() {
  let store;

  beforeEach(function() {
    store = {
      fetchProjects: function() {},
      getProjects: function() { return [{ title: "A", badges: [] }, { title: "B", badges: [] }] },
      observe: function() {},
      unobserve: function() {}
    };
  });

  context("when there are projects", function() {
    it("renders each project", function() {
      let component = TestUtils.renderIntoDocument(
        <Wall store={store} />
      );
      let projects = TestUtils.scryRenderedComponentsWithType(component, Project);
      expect(projects).to.have.length(2);
    });
  });

  context("when there are no projects", function() {
    let projects;

    beforeEach(function() {
      projects = [];
      sandbox.stub(store, 'getProjects').returns(projects);
    });

    it("shows a placeholder when there are no projects", function() {
      let component = TestUtils.renderIntoDocument(
        <Wall store={store} />
      );
      expect(component).to.have.childComponent({ className: "placeholder" });
    });

    it("hides the placeholder and shows projecs when the store updates", function() {
      let component = TestUtils.renderIntoDocument(
        <Wall store={store} />
      );
      expect(component).to.have.childComponent({ className: "placeholder" });
      projects.push({ title: "A", badges: []});
      component.handleUpdates();
      expect(component).not.to.have.childComponent({ className: "placeholder" });
      expect(component).to.have.childComponent({ type: Project });
    });
  });
});
