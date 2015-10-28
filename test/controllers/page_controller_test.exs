defmodule Wally.PageControllerTest do
  use Wally.ConnCase

  setup do
    Exredis.Api.flushdb
    :ok
  end

  test "GET / when not logged in redirects to log in page" do
    conn = conn()
    |> get("/")
    assert redirected_to(conn) == "/login"
  end

  test "GET / renders a loading page when logged in" do
    conn = conn()
    |> post("/login", %{username: "test", password: "supersecret"})
    |> get("/")
    assert html_response(conn, 200) =~ "Loading"
  end

  test "GET / includes seed data when logged in" do
    conn = conn()
    |> post("/login", %{username: "test", password: "supersecret"})
    |> get("/")
    refute is_nil(conn.assigns.initial_state)
  end
end
