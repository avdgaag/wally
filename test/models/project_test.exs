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

  test "fetches records by subset of settings" do
    Repo.insert %Project{title: "Project 1", settings: %{foo: "bar", baz: "qux"}}
    assert length(Repo.all(Project.by_settings(%{foo: "bar"}))) == 1
    assert length(Repo.all(Project.by_settings(%{baz: "qux"}))) == 1
    assert length(Repo.all(Project.by_settings(%{foo: "bar", baz: "qux"}))) == 1
    assert length(Repo.all(Project.by_settings(%{baz: "bla"}))) == 0
    assert length(Repo.all(Project.by_settings(%{foo: "bar", baz: "bla"}))) == 0
  end
end
