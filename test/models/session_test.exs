defmodule Wally.SessionTest do
  use Wally.ConnCase
  alias Wally.Session
  alias Wally.User

  setup do
    session_opts = Plug.Session.init(store: :cookie, key: "app", signing_salt: "test")
    conn = conn()
           |> Plug.Session.call(session_opts)
           |> fetch_session
           |> fetch_query_params
    {:ok, conn: conn}
  end

  test "stores user ID in the session on authentication", %{conn: conn} do
    c = conn
    |> Session.login(%Wally.User{id: 1})
    assert c.private.plug_session["user_id"] == 1
  end

  test "removes user ID from the session on logout", %{conn: conn} do
    c = conn
    |> put_session(:user_id, "1")
    |> Session.logout
    assert c.private.plug_session["user_id"] == nil
  end

  test "retrieves the current user based on the session user ID", %{conn: conn} do
    user = Repo.insert(User.changeset(%User{}, %{"email" => "email", "password" => "password"}))
    c = conn
    |> put_session(:user_id, user.id)
    assert Session.current_user(c) == user
  end

  test "retrieves no current user when there is no session user ID set", %{conn: conn} do
    assert Session.current_user(conn) == nil
  end

  test "is logged in when there is a current user", %{conn: conn} do
    user = Repo.insert(User.changeset(%User{}, %{"email" => "email", "password" => "password"}))
    c = conn
    |> put_session(:user_id, user.id)
    assert Session.logged_in?(c)
  end

  test "retrieves no current user when the session user ID is invalid", %{conn: conn} do
    c = conn
    |> put_session(:user_id, 1)
    assert Session.current_user(c) == nil
  end

  test "is not logged in when there is no current user", %{conn: conn} do
    refute Session.logged_in?(conn)
  end

  test "has no curren token without parameter", %{conn: conn} do
    assert Session.current_token(conn) == nil
  end

  test "is not token authenticated without parameter", %{conn: conn} do
    refute Session.token_authenticated?(conn)
  end

  test "is not token authenticated with an invalid token parameter", %{conn: conn} do
    c = %{conn | params: Map.put(conn.params, "api_token", "foobar")}
    refute Session.token_authenticated?(c)
  end

  test "is token authenticated with a valid token parameter", %{conn: conn} do
    api_token = Wally.Repo.insert(%Wally.ApiToken{description: "test"})
    c = %{conn | params: Map.put(conn.params, "api_token", api_token.token)}
    assert Session.token_authenticated?(c)
  end
end
