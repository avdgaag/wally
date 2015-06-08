defmodule Wally.PageControllerTest do
  use Wally.ConnCase

  test "GET /" do
    Wally.Repo.insert(Wally.User.changeset(%Wally.User{}, %{"email" => "email", "password" => "password"}))
    conn = conn()
    conn = post(conn, session_path(conn, :create, user: %{email: "email", password: "password"}))
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Wally"
  end
end
