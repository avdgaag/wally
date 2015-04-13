import Project from "../../../web/static/js/components/project";
import Badge from "../../../web/static/js/components/badge";

describe("Project", function() {
  it("renders its own title", function() {
    let component = TestUtils.renderIntoDocument(
      <Project project={{ title: "My project", badges: [] }} />
    );
    expect(component).to.have.childComponent({ className: "project__title", innerHtml: "My project" });
  });

  it("renders each badge", function() {
    let component = TestUtils.renderIntoDocument(
      <Project project={{ title: "My project", badges: [{ label: "CI", value: "Passing" }] }} />
    );
    let badge = TestUtils.findRenderedComponentWithType(component, Badge);
    expect(badge.props.badge).to.eql({ label: "CI", value: "Passing" });
  });
});
