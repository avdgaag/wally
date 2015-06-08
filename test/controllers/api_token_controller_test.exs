defmodule Wally.ApiTokenControllerTest do
  use Wally.ConnCase

  alias Wally.ApiToken
  @valid_params api_token: %{description: "some content"}
  @invalid_params api_token: %{description: ""}

  setup do
    Wally.Repo.insert(Wally.User.changeset(%Wally.User{}, %{"email" => "email", "password" => "password"}))
    conn = conn()
    conn = post(conn, session_path(conn, :create, user: %{email: "email", password: "password"}))
    {:ok, conn: conn}
  end

  test "GET /api_tokens", %{conn: conn} do
    conn = get conn, api_token_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing API tokens"
  end

  test "GET /api_tokens/new", %{conn: conn} do
    conn = get conn, api_token_path(conn, :new)
    assert html_response(conn, 200) =~ "New API token"
  end

  test "POST /api_tokens with valid data", %{conn: conn} do
    conn = post conn, api_token_path(conn, :create), @valid_params
    assert redirected_to(conn) == api_token_path(conn, :index)
  end

  test "POST /api_tokens with invalid data", %{conn: conn} do
    conn = post conn, api_token_path(conn, :create), @invalid_params
    assert html_response(conn, 200) =~ "New API token"
  end

  test "DELETE /api_tokens/:id", %{conn: conn} do
    api_token = Repo.insert %ApiToken{description: "test token", token: "foobar"}
    conn = delete conn, api_token_path(conn, :delete, api_token)
    assert redirected_to(conn) == api_token_path(conn, :index)
    refute Repo.get(ApiToken, api_token.id)
  end
end
