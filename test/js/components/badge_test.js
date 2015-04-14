import Badge from "../../../web/static/js/components/badge";
import UpdatingTimestamp from "../../../web/static/js/components/updating_timestamp";
import Checkmark from "../../../web/static/js/components/checkmark";

describe("Badge", function() {
  it("renders count and title", function() {
    let component = TestUtils.renderIntoDocument(
      <Badge badge={{ label: "CI", value: "Passing" }} />
    );
    expect(component).to.have.childComponent({ className: 'badge__value', innerHtml: "Passing" });
    expect(component).to.have.childComponent({ className: 'badge__label', innerHtml: "CI" });
  });

  it("renders an UpdatingTimestamp when the value looks like a timestamp", function() {
    let component = TestUtils.renderIntoDocument(
      <Badge badge={{ label: "CI", value: "2015-04-13 12:33:21" }} />
    );
    expect(component).to.have.childComponent({ type: UpdatingTimestamp });
  });

  it("renders a Checkmark when the value looks like a boolean status", function() {
    let component = TestUtils.renderIntoDocument(
      <Badge badge={{ label: "CI", value: "Passed" }} />
    );
    expect(component).to.have.childComponent({ type: Checkmark });
  });
});
