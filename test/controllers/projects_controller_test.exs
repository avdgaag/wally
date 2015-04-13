defmodule Wally.ProjectsControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo

  test "GET /api/projects" do
    projects_as_json =
      %Project{title: "My first project"}
      |> Repo.insert
      |> List.wrap
      |> Poison.encode!
    response = get conn(), "/api/projects"
    assert response.status == 200
    assert response.resp_body == projects_as_json
  end
end
