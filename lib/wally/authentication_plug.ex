defmodule Wally.AuthenticationPlug do
  import Plug.Conn,
         only: [halt: 1, send_resp: 3]
  import Phoenix.Controller,
         only: [put_flash: 3, redirect: 2]
  import Wally.Session,
         only: [logged_in?: 1, token_authenticated?: 1]

  def require_login(conn, _opts \\ %{}) do
    if logged_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You need to log in first.")
      |> redirect(to: Wally.Router.Helpers.session_path(conn, :new))
      |> halt
    end
  end

  def require_api_token(conn, _opts \\ %{}) do
    if token_authenticated?(conn) do
      conn
    else
      conn
      |> send_resp(401, "")
      |> halt
    end
  end
end
