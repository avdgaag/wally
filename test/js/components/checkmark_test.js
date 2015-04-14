import Checkmark from "../../../web/static/js/components/checkmark";

describe("Checkmark", function() {
  it("matches common CI status keywords", function() {
    expect(Checkmark.matches("Passed")).to.be.ok;
    expect(Checkmark.matches("Failed")).to.be.ok;
  });

  it("displays a symbol for the given status", function() {
    let component = TestUtils.renderIntoDocument(
      <Checkmark status="Passed" />
    );
    expect(component).to.have.innerHtml("✓");
  });
});
