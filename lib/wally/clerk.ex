defmodule Wally.Clerk do
  import Ecto.Query
  import Enum, only: [map: 2, each: 2, find: 3]
  alias Wally.Repo
  alias Wally.Badge
  alias Wally.Project

  @moduledoc """
  Responsible for reaching into the database and updating
  relevant projects and badges using the information passed in.
  """

  @doc """
  Update a project badge by finding the project using an
  idintifier and either creating or updating its relevant
  badge.

  The project identifier is a struct whose key/value is looked
  up in the `projects.settings` JSONB column.

  This will update multiple projects, if found.

  Example usage:

      Wally.Clerk.update(%{ heroku_app: "myapp" }, "just now", "Deployment")
  """
  def update(identifier, value, label) do
    projects_query(identifier)
    |> Repo.all
    |> map(&(find_badge &1, label))
    |> map(&(%Badge{&1 | value: value}))
    |> map(&insert_or_update_badge/1)
    |> each(&broadcast/1)
  end

  defp projects_query(identifier) do
    from project in Project,
      preload: [:badges],
      where: fragment("? @> ?::jsonb", project.settings, ^identifier)
  end

  defp broadcast(badge) do
    Wally.Endpoint.broadcast! "notifications", "project:update", badge
  end

  defp insert_or_update_badge(%Badge{id: nil} = badge) do
    Repo.insert(badge)
  end

  defp insert_or_update_badge(badge) do
    Repo.update(badge)
  end

  defp find_badge(project, label) do
    new_badge = %Badge{label: label, project_id: project.id}
    find project.badges, new_badge, &(&1.label == label)
  end
end
