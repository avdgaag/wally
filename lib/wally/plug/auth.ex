defmodule Wally.Plug.Auth do

  @moduledoc """
  Plug for reading the current user from the session and assigning
  it to the current connection. If there is no current user, redirect
  to the log in page.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_session(conn, :current_user)
    conn
    |> assign(:current_user, user)
  end
end
