defmodule Wally.WallController do
  use Wally.Web, :controller
  alias Wally.Repo
  alias Wally.Project

  plug :action

  def index(conn, _params) do
    projects = Repo.all(Project) |> Repo.preload(:badges)
    json conn, projects
  end
end
