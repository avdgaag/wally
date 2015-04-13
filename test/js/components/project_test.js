import Project from "../../../web/static/js/components/project";

describe("Project", function() {
  it("renders its own title", function() {
    let component = TestUtils.renderIntoDocument(
      <Project project={{ title: "My project", badges: [] }} />
    );
    expect(component).to.have.childComponent({ className: "project__title", innerHtml: "My project" });
  });
});
