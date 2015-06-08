defmodule Wally.WallControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo

  setup do
    Wally.Repo.insert(Wally.User.changeset(%Wally.User{}, %{"email" => "email", "password" => "password"}))
    conn = conn()
    conn = post(conn, session_path(conn, :create, user: %{email: "email", password: "password"}))
    {:ok, conn: conn}
  end

  test "GET /wall", %{conn: conn} do
    projects_as_json =
      %Project{title: "My first project"}
      |> Repo.insert
      |> Repo.preload(:badges)
      |> List.wrap
      |> Poison.encode!
    response = get conn, "/wall"
    assert response.status == 200
    assert response.resp_body == projects_as_json
  end
end
