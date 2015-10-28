defmodule Wally.SessionController do
  use Wally.Web, :controller
  import Wally.Session, only: [sign_in_user: 2, sign_in_failed: 1]

  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"username" => "test", "password" => password}) do
    test_password = Application.get_env(:wally, :authentication)[:password]
    case password do
      ^test_password ->
        sign_in_user(conn, Wally.User.test_user)
      _ ->
        sign_in_failed(conn)
    end
  end

  def destroy(conn, _) do
    conn
    |> delete_session(:current_user)
    |> delete_session(:access_token)
    |> put_flash(:info, "You were logged out.")
    |> redirect(to: "/login")
  end
end
