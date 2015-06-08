defmodule Wally.SessionControllerTest do
  use Wally.ConnCase

  setup do
    {:ok, conn: conn()}
  end

  @valid_params %{user: %{email: "email", password: "password"}}
  @invalid_params %{user: %{email: "foo", password: "bar"}}

  test "GET /login", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Log in"
  end

  test "GET /login with valid params" do
    Wally.Repo.insert(Wally.User.changeset(%Wally.User{}, %{"email" => "email", "password" => "password"}))
    conn = post conn, session_path(conn, :create, @valid_params)
    assert redirected_to(conn, 302) == "/projects"
    assert get_flash(conn, :info) == "You have been logged in."
  end

  test "GET /login with invalid params" do
    conn = post conn, session_path(conn, :create, @invalid_params)
    assert redirected_to(conn, 302) == "/login"
    assert get_flash(conn, :error) == "The given combination of username and password was incorrect. Please try again."
  end

  test "GET /logout", %{conn: conn} do
    conn = get conn, session_path(conn, :delete)
    assert redirected_to(conn, 302) == "/login"
    assert get_flash(conn, :info) == "You have been logged out."
  end
end
