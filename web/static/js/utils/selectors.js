import { createSelector } from 'reselect';
import Immutable from 'immutable';
import addStatuses from './project_statuses';

export const projectsSelector = state => state.get('projects');

const eventsSelector = state => state.get('events');

/*
 * Take a map of projects and events and return a map of projects with a new
 * `event` key holding the events referenced by the project's `eventIds` key.
 */
const projectsWithEvents = createSelector(
  [projectsSelector, eventsSelector],
  (projects, events) => {
    return projects.map(project => {
      const projectEvents = Immutable.List(project.get('eventIds').map(id => events.get(id)));
      return project.set('events', projectEvents);
    });
  }
);

/*
 * Take a map of projects and calculate aggregate statuses from their list of
 * events.
 *
 * See ./project_statuses.js
 */
export const projectsWithAggregatedEvents = createSelector(
  [projectsWithEvents],
  projects => projects.map(addStatuses)
);

/*
 * Take projects and events and produce a list of events with a new `project`
 * property assigned based on its `projectId` property.
 */
const eventsWithProjectSelector = createSelector(
  [projectsSelector, eventsSelector],
  (projects, events) => events.map(event => event.set('project', projects.get(event.get('projectId').toString())))
);

/*
 * Take a map of events and filter out any event that does not have a type
 * of `'deployment'` or `'ci'`.
 */
const highlightedEventsSelector = createSelector(
  [eventsWithProjectSelector],
  events => events.filter(event => event.get('type') === 'deployment' || event.get('type') === 'ci')
);

/*
 * Group a map of events by its type, producing a map of types and lists of
 * events.
 */
const eventsByTypeSelector = createSelector(
  [highlightedEventsSelector],
  events => {
    return events.reduce((acc, event) => {
      return acc.update(event.get('type'), Immutable.List(), list => list.push(event));
    }, Immutable.Map());
  }
);

/*
 * Take a map of grouped events and for each event type (the key) find the most
 * recent event in the list of events (the value). Produces a map of event types
 * and most recent event.
 */
export const latestEventsSelector = createSelector(
  [eventsByTypeSelector],
  groupedEvents => groupedEvents.map(events => events.maxBy(event => event.get('date')))
);

export const mainSelector = state => {
  return Immutable.Map({
    projects: projectsWithAggregatedEvents(state),
    events: latestEventsSelector(state)
  });
};
