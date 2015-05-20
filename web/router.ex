defmodule Wally.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wally do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/projects", ProjectController
  end

  scope "/api", Wally do
    pipe_through :api

    get "/wall", WallController, :index

    post "/hooks/codeship", CodeshipController, :index
    post "/hooks/heroku", HerokuController, :index
  end

  socket "/ws", Wally do
    channel "notifications", NotificationsChannel
  end
end
