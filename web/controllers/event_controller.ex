defmodule Wally.EventController do
  use Wally.Web, :controller

  plug :authenticate_webhook

  def github_status(conn, params) do
    params |> Event.github_status |> handle_event(conn)
  end

  def errbit_exception(conn, params) do
    params |> Event.errbit_exception |> handle_event(conn)
  end

  def heroku_deployment(conn, params) do
    params |> Event.heroku_deployment |> handle_event(conn)
  end

  defp handle_event({:ok, new_event}, conn) do
    {:ok, event} = Repo.persist(new_event)
    :ok = Wally.Repo.associate(conn.assigns.project, event)
    event
    |> Wally.Serializer.event
    |> Actions.new_event
    conn
    |> put_status(200)
    |> text("")
  end

  defp handle_event({:ignored, msg}) do
    conn |> put_status(200) |> text(msg)
  end

  defp handle_event({_, msg}, conn) do
    conn |> put_status(403) |> text(msg)
  end

  defp authenticate_webhook(conn, _options) do
    case Repo.get_by(Project, :api_token, conn.params["webhook_token"]) do
      {:error, msg} -> conn |> put_status(404) |> text(msg) |> halt
      {:ok, project} -> conn |> Plug.Conn.assign(:project, project)
    end
  end
end
