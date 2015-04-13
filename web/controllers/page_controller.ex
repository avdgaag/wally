defmodule Wally.PageController do
  use Wally.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
