# Wally

A toy software status wall application built with [Elixir][], [Phoenix][] and
[React][]. Use it to display your CI build status and latest project activity on
a big screen in the office.

**Quite a work in progress**.

## Installation

This project requires both a working installation of [Elixir][] and [Node.js][]
(with [NPM][] installed). It uses [PostgreSQL][] as its database.

To start your new Phoenix application:

1. Install dependencies with `mix deps.get` and then `npm install`.
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

## Testing

You can run this project's tests in two parts:

* Test Elixir back-end code with `mix test`.
* Test Javascript front-end code with `npm test`.

## Overview

This application renders a list of projects and their status on the client side,
while receiving web hooks from external services on the server side. Using
websockets, the client is updated immediately.

Currently the only implemented web hooks are:

* a Heroku deployment notification;
* a Codeship build status notification.

## Plugins and widgets

The aim is to divide this project into three parts:

* the infrastructure to manage projects and show the status wall;
* plugins that can accept a range of incoming web hooks (a Phoenix controller
  written in Elixir);
* widgets to present data in the browser to the client (a React component
  written in Javascript).

## Deploy to Heroku

To deploy this application to a new Heroku application, use this button:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Note that Wally requires Postgres 9.4 with JSONB support. You can actually your
database and start using the app:

    % heroku run mix ecto.migrate

[Elixir]: http://elixir-lang.org/
[Phoenix]: http://www.phoenixframework.org/
[React]: https://facebook.github.io/react/
[Node.js]: https://nodejs.org/
[NPM]: https://www.npmjs.com/
[PostgreSQL]: http://www.postgresql.org/
