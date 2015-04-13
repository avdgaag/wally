defmodule Wally.ProjectsController do
  use Wally.Web, :controller
  alias Wally.Repo
  alias Wally.Project

  plug :action

  def index(conn, _params) do
    projects = Repo.all(Project)
    json conn, projects
  end
end
