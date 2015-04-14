import getJson from './get_json';

let projects = [];
let observers = [];

function notifyObservers() {
  observers.forEach(observer => { observer() });
}

function extend() {
  let objects = Array.prototype.slice.call(arguments);
  return objects.reduce(function(output, object) {
    for(let prop in object) {
      if(object.hasOwnProperty(prop)) {
        output[prop] = object[prop];
      }
    }
    return output;
  });
}

let ProjectStore = {
  getProjects() {
    return projects;
  },

  fetchProjects() {
    return getJson('/api/projects').then(function(objs) {
      projects = objs;
      notifyObservers();
    });
  },

  observe(fn) {
    observers.push(fn);
  },

  unobserve(fn) {
    let index = observers.indexOf(fn);
    if(index !== -1) {
      observers.splice(index, 1);
    }
  },

  updateBadge(newBadge) {
    let project = projects.find(p => p.id == newBadge.project_id);
    if(project) {
      let badge = project.badges.find(badge => badge.id == newBadge.id);
      if(badge) {
        extend(badge, newBadge);
      } else {
        project.badges.push(badge);
      }
      notifyObservers();
    }
  }
};

export default ProjectStore;
