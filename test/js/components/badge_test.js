import Badge from "../../../web/static/js/components/badge";

describe("Badge", function() {
  it("renders count and title", function() {
    let component = TestUtils.renderIntoDocument(
      <Badge badge={{ label: "CI", value: "Passing" }} />
    );
    expect(component).to.have.childComponent({ className: 'badge__value', innerHtml: "Passing" });
    expect(component).to.have.childComponent({ className: 'badge__label', innerHtml: "CI" });
  });
});
