defmodule Wally.Router do
  use Wally.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Wally.Plug.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wally do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/logout", SessionController, :destroy
    post "/login", SessionController, :create
  end

  scope "/auth", Wally do
    pipe_through :browser
    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api/", Wally do
    pipe_through :api

    scope "/hooks/:webhook_token/" do
      post "/heroku", EventController, :heroku_deployment
      post "/errbit", EventController, :errbit_exception
      post "/github", EventController, :github_status
    end
  end
end
