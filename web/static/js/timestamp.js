let matcher = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/;

function parseDateString(str) {
  let matches = matcher.exec(str);
  if(!matches) throw Error("Not a valid datetime string: " + str);
  return new Date(matches[1], matches[2] - 1, matches[3], matches[4], matches[5], matches[6]);
}

export default class Timestamp {
  constructor(str) {
    this.date = parseDateString(str);
  }

  inWords(fromDate) {
    if(!fromDate) fromDate = new Date();

    let seconds = Math.floor((fromDate - this.date) / 1000);
    let interval;

    interval = Math.floor(seconds / 31536000);
    if (interval > 1) {
      return interval + " years";
    }
    interval = Math.floor(seconds / 2592000);
    if (interval > 1) {
      return interval + " months";
    }
    interval = Math.floor(seconds / 86400);
    if (interval > 1) {
      return interval + " days";
    }
    interval = Math.floor(seconds / 3600);
    if (interval > 1) {
      return interval + " hours";
    }
    interval = Math.floor(seconds / 60);
    if (interval > 1) {
      return interval + " minutes";
    }
    return Math.floor(seconds) + " seconds";
  }
}

Timestamp.matches = function(str) {
  return matcher.test(str);
};
