defmodule Wally.Session do
  @doc """
  Shared functions for signing users in and out of a session.
  """

  import Plug.Conn, only: [put_session: 3, configure_session: 2, put_status: 2, halt: 1]
  import Phoenix.Controller, only: [redirect: 2, text: 2]

  def sign_in_user(conn, user) do
    conn
    |> put_session(:current_user, user)
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end

  def sign_in_failed(conn) do
    conn
    |> put_status(:unauthorized)
    |> text("")
    |> halt
  end
end
