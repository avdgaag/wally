defmodule Wally.CodeshipController do
  use Wally.Web, :controller
  alias Wally.Clerk

  plug :action

  def index(conn, %{ "build" => %{ "project_id" => project_id, "status" => status } } = _params) do
    Clerk.update(%{ codeship_project_id: project_id }, status, "Codeship")
    conn
    |> put_status(200)
    |> text ""
  end

  def index(conn, _params) do
    conn
    |> put_status(422)
    |> text ""
  end
end
