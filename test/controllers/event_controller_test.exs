defmodule Wally.EventControllerTest do
  use Wally.ConnCase

  setup do
    Exredis.Api.flushdb
    {:ok, _} = Wally.Repo.persist(%Wally.Project{api_token: "foobar"}, [:api_token])
    :ok
  end

  @valid_params %{
    "app" => "myapp",
    "git_log" => "  * name: action",
    "head" => "abc123",
    "user" => "john@example.com",
    "release" => "v7"
  }

  test "heroku_deployment returns ok" do
    conn = post conn(), "/api/hooks/foobar/heroku", @valid_params
    assert text_response(conn, 200) == ""
  end

  test "heroku_deployment creates a new event" do
    post conn(), "/api/hooks/foobar/heroku", @valid_params
    assert Exredis.Api.scard("event_ids") == "1"
  end

  test "heroku_deployment publishes new event" do
    Phoenix.PubSub.subscribe(Wally.PubSub, self(), "actions")
    post conn(), "/api/hooks/foobar/heroku", @valid_params
    assert [%{event: "event:new"} | _] = Process.info(self)[:messages]
    Phoenix.PubSub.unsubscribe(Wally.PubSub, self(), "actions")
  end

  test "renders 404 when params are invalid" do
    conn = post conn(), "api/hooks/foobar/heroku", %{}
    assert text_response(conn, 403) == "Invalid inputs"
  end

  test "renders 404 when token is invalid" do
    conn = post conn(), "/api/hooks/invalid/heroku", @valid_params
        assert text_response(conn, 404) == "No such api_token"
  end
end
