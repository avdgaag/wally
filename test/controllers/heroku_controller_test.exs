defmodule Wally.HerokuControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo
  alias Wally.Badge
  alias Wally.ApiToken

  setup do
    {:ok, conn: conn(), token: Repo.insert(%ApiToken{description: "Test token"}).token}
  end

  test "inserts new badge for project with Heroku app name", %{conn: conn, token: token} do
    Repo.insert(%Project{title: "Demo", settings: %{"heroku_app" => "myapp"}})
    response = post conn, "/api/" <> token <> "/hooks/heroku", app: "myapp"
    assert response.status == 200
    assert response.resp_body == ""
    assert length(Repo.all(Badge)) == 1
  end

  test "it fails quickly when input is not as expected", %{conn: conn, token: token} do
    response = post conn, "/api/" <> token <> "/hooks/heroku"
    assert response.status == 422
    assert response.resp_body == ""
  end

  test "it returns authorisation failure when using a wrong token", %{conn: conn} do
    response = post conn, "/api/sillytoken/hooks/heroku"
    assert response.status == 401
    assert response.resp_body == ""
  end
end
