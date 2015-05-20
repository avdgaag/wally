defmodule Wally.ProjectTest do
  use Wally.ModelCase

  alias Wally.Project

  @valid_attrs %{title: "some content", settings: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "deletion cascades to badges" do
    project = Repo.insert %Project{title: "My project"}
    Repo.insert %Wally.Badge{project_id: project.id, label: "Label", value: "value"}
    assert length(Repo.all(Wally.Badge)) == 1
    Repo.delete project
    assert length(Repo.all(Wally.Badge)) == 0
  end

  test "fetches records chronologically" do
    project1 = Repo.insert %Project{title: "Project 1"}
    project2 = Repo.insert %Project{title: "Project 2"}
    results = Repo.all Project.chronologically
    assert results == [project1, project2]
  end

  test "fetches records by subset of settings" do
    Repo.insert %Project{title: "Project 1", settings: %{foo: "bar", baz: "qux"}}
    assert length(Repo.all(Project.by_settings(%{foo: "bar"}))) == 1
    assert length(Repo.all(Project.by_settings(%{baz: "qux"}))) == 1
    assert length(Repo.all(Project.by_settings(%{foo: "bar", baz: "qux"}))) == 1
    assert length(Repo.all(Project.by_settings(%{baz: "bla"}))) == 0
    assert length(Repo.all(Project.by_settings(%{foo: "bar", baz: "bla"}))) == 0
  end
end
