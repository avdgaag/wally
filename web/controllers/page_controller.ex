defmodule Wally.PageController do
  use Wally.Web, :controller

  plug :require_authentication

  def index(conn, _params) do
    projects = Project |> load_records |> Wally.Serializer.projects
    events   = Event   |> load_records |> Wally.Serializer.events
    payload = Poison.encode!(%{projects: projects, events: events})
    conn
    |> assign(:initial_state, payload)
    |> render("index.html")
  end

  defp require_authentication(conn, _options) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:alert, "You need to log in first.")
      |> redirect(to: Wally.Router.Helpers.session_path(conn, :new))
      |> halt()
    end
  end

  defp load_records(mod) do
    {:ok, records} = Repo.all(mod)
    records
  end
end
