import UpdatingTimestamp from "../../../web/static/js/components/updating_timestamp";

describe("UpdatingTimestamp", function() {
  let clock;

  beforeEach(function() {
    clock = sinon.useFakeTimers(Date.UTC(2015, 3, 15, 12, 0, 0));
  });

  afterEach(function() {
    clock.restore();
  });

  it("renders the time ago in words", function() {
    let component = TestUtils.renderIntoDocument(
      <UpdatingTimestamp timestamp="2015-04-14 12:00:00" />
    );
    expect(component).to.have.innerHtml("24 hours");
  });

  it("automatically re-renders every minute", function() {
    let component = TestUtils.renderIntoDocument(
      <UpdatingTimestamp timestamp="2015-04-15 11:59:00" />
    );
    expect(component).to.have.innerHtml("60 seconds");
    clock.tick(60000);
    expect(component).to.have.innerHtml("2 minutes");
  });
});
