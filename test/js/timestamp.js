import Timestamp from "../../web/static/js/timestamp";

describe("Timestamp", function() {
  it("matches a properly formatted datetime", function() {
    expect(Timestamp.matches("2015-04-01 12:21:30")).to.be.ok
  });

  it("does not match other strings", function() {
    expect(Timestamp.matches("foobar")).not.to.be.ok
  });

  it("renders a timestamp as time ago in words", function() {
    let timestamp = new Timestamp("2015-04-01 12:21:30");
    let fromDate = new Date(2015, 3, 2, 5, 0, 0);
    expect(timestamp.inWords(fromDate)).to.eql("16 hours");
  });
});
