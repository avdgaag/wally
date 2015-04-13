defmodule Wally.HerokuControllerTest do
  use Wally.ConnCase
  alias Wally.Project
  alias Wally.Repo
  alias Wally.Badge

  test "inserts new badge for project with Heroku app name" do
    Repo.insert(%Project{ title: "Demo", settings: %{ "heroku_app" => "myapp" } })
    response = post conn(), "/api/hooks/heroku", app: "myapp"
    assert response.status == 200
    assert response.resp_body == ""
    assert length(Repo.all(Badge)) == 1
  end

  test "it fails quickly when input is not as expected" do
    response = post conn(), "/api/hooks/heroku"
    assert response.status == 422
    assert response.resp_body == ""
  end
end
