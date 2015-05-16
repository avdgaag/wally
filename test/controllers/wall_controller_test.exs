defmodule Wally.WallControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo

  test "GET /api/wall" do
    projects_as_json =
      %Project{title: "My first project"}
      |> Repo.insert
      |> Repo.preload(:badges)
      |> List.wrap
      |> Poison.encode!
    response = get conn(), "/api/wall"
    assert response.status == 200
    assert response.resp_body == projects_as_json
  end
end
