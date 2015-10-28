import lodash from 'lodash';

const addMasterBuildStatus = project => {
  let mbs = project.get('events').
        filter(event => event.get('type') === 'ci').
        filter(event => event.get('subject') === 'master').
        maxBy(event => event.get('date'));
  if(mbs) {
    mbs = mbs.get('status') === 'success';
  }
  return project.set('masterBuildStatus', mbs);
};

const addLastBuildStatus = project => {
  let lbs = project.get('events').
        filter(event => event.get('type') === 'ci').
        filter(event => event.get('subject') !== 'master').
        maxBy(event => event.get('date'));
  if(lbs) {
    lbs = lbs.get('status') === 'success';
  }
  return project.set('lastBuildStatus', lbs);
};

const addRecentExceptionsCount = project => {
  const rec = project.get('events').
          filter(event => event.get('type') === 'exception').
          size;
  return project.set('recentExceptionsCount', rec);
};

export default lodash.compose(
  addMasterBuildStatus,
  addLastBuildStatus,
  addRecentExceptionsCount
);
