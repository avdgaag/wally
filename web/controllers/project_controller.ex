defmodule Wally.ProjectController do
  use Wally.Web, :controller

  alias Wally.Project

  plug :scrub_params, "project" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    projects = Repo.all(Project.chronologically)
    render(conn, "index.html", projects: projects)
  end

  def new(conn, _params) do
    changeset = Project.changeset(%Project{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project" => project_params}) do
    {regular_params, settings} = Dict.split(project_params, ["title"])
    params = Dict.put regular_params, "settings", settings
    changeset = Project.changeset(%Project{}, params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Project created successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    render(conn, "show.html", project: project)
  end

  def edit(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    changeset = Project.changeset(project)
    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    {regular_params, settings} = Dict.split(project_params, ["title"])
    params = Dict.put regular_params, "settings", settings
    project = Repo.get(Project, id)
    changeset = Project.changeset(project, params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Project updated successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get(Project, id)
    Repo.delete(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end
end
