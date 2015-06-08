defmodule Wally.CodeshipControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo
  alias Wally.Badge

  defp post_json(conn, token, json_struct) do
    conn
    |> put_req_header("content-type", "application/json")
    |> post "/api/" <> token <> "/hooks/codeship", Poison.encode!(json_struct)
  end

  setup do
    {:ok, conn: conn(), token: Repo.insert(%Wally.ApiToken{description: "Test token"}).token}
  end

  test "inserts new badge for project with Codeship project ID", %{conn: conn, token: token} do
    Repo.insert(%Project{ title: "Demo", settings: %{ "codeship_project_id" => 1 } })
    response = post_json(conn, token, %{build: %{ project_id: 1, status: "passed" }})
    assert response.status == 200
    assert response.resp_body == ""
    assert length(Repo.all(Badge)) == 1
  end

  test "it fails quickly when input is not as expected", %{conn: conn, token: token} do
    response = post_json(conn, token, %{build: %{}})
    assert response.status == 422
    assert response.resp_body == ""
  end
end
