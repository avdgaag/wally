defmodule Wally.CodeshipControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo
  alias Wally.Badge

  defp post_json(json_struct) do
    conn
    |> put_req_header("content-type", "application/json")
    |> post "/api/hooks/codeship", Poison.encode!(json_struct)
  end

  test "inserts new badge for project with Codeship project ID" do
    Repo.insert(%Project{ title: "Demo", settings: %{ "codeship_project_id" => 1 } })
    response = post_json(%{build: %{ project_id: 1, status: "passed" }})
    assert response.status == 200
    assert response.resp_body == ""
    assert length(Repo.all(Badge)) == 1
  end

  test "it fails quickly when input is not as expected" do
    response = post_json(%{build: %{}})
    assert response.status == 422
    assert response.resp_body == ""
  end
end
