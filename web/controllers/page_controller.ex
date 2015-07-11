defmodule Wally.PageController do
  use Wally.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn,
      "index.html",
      hide_menu: true,
      api_token: Wally.Session.current_user(conn).api_token
  end
end
