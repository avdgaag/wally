defmodule Wally.SessionController do
  use Wally.Web, :controller
  import Wally.Session,
         only: [login: 2, logout: 1]

  plug :scrub_params, "user" when action in [:create]
  plug :action

  def new(conn, _params) do
    conn
    |> render("new.html", hide_menu: true, changeset: Wally.User.changeset(%Wally.User{}))
  end

  def create(conn, %{"user" => %{ "email" => email, "password" => password }}) do
    case Wally.User.authenticate(email, password) do
      {:ok, user} ->
        conn
        |> login(user)
        |> put_flash(:info, "You have been logged in.")
        |> redirect(to: project_path(conn, :index))
      _ ->
        conn
        |> put_flash(:error, "The given combination of username and password was incorrect. Please try again.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> logout
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: session_path(conn, :new))
  end
end
