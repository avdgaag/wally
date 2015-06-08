defmodule Wally.Router do
  use Phoenix.Router
  import Wally.AuthenticationPlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :authenticated do
    plug :require_login
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :require_api_token
  end

  scope "/", Wally do
    pipe_through :browser # Use the default browser stack
    pipe_through :authenticated

    get "/", PageController, :index
    get "/wall", WallController, :index
    resources "/projects", ProjectController
    resources "/api_tokens", ApiTokenController
  end

  scope "/", Wally do
    pipe_through :browser
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
  end

  scope "/api/:api_token", Wally do
    pipe_through :api

    post "/hooks/codeship", CodeshipController, :index
    post "/hooks/heroku", HerokuController, :index
  end

  socket "/ws", Wally do
    channel "notifications", NotificationsChannel
  end
end
