# Wally

A toy software status wall application built with [Elixir][], [Phoenix][] and
[React][]. Use it to display you CI build status and latest project activity on
a big screen in the office.

**Quite a work in progress**.

## Installation

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

## Overview

This application renders a list of projects and their status on the client side,
while receiving web hooks from external services on the server side. Using
websockets, the client is updated immediately.

Currently the only implemented web hook is a Heroku depoyment notification.

[Elixir]: http://elixir-lang.org/
[Phoenix]: http://www.phoenixframework.org/
[React]: https://facebook.github.io/react/
