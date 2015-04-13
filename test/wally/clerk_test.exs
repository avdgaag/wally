defmodule Wally.ClerkTest do
  use ExUnit.Case
  alias Wally.Repo
  alias Wally.Project
  alias Wally.Badge
  alias Wally.Clerk

  setup do
    Ecto.Adapters.SQL.restart_test_transaction(Repo, [])
    :ok
  end

  test "inserts new badge for project with Codeship project ID" do
    Repo.insert(%Project{ title: "Demo", settings: %{ "codeship_project_id" => 1 } })
    Clerk.update(%{ codeship_project_id: 1 }, "passed", "Codeship")
    badges = Repo.all(Badge)
    assert length(badges) == 1
    badge = List.first(badges)
    assert badge.value == "passed"
    assert badge.label == "Codeship"
  end

  test "updates existing badge for project with Codeship project ID" do
    project = Repo.insert(%Project{ title: "Demo", settings: %{ "codeship_project_id" => 1 } })
    Repo.insert(%Badge{ project_id: project.id, value: "failed", label: "Codeship" })
    Clerk.update(%{ codeship_project_id: 1 }, "passed", "Codeship")
    badges = Repo.all(Badge)
    assert length(badges) == 1
    badge = List.first(badges)
    assert badge.value == "passed"
    assert badge.label == "Codeship"
  end

  test "does nothing when Codeship project ID cannot be found" do
    Clerk.update(%{ codeship_project_id: 2 }, "passed", "Codeship")
    assert length(Repo.all(Badge)) == 0
  end
end
