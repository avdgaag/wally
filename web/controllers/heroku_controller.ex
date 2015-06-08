defmodule Wally.HerokuController do
  use Wally.Web, :controller
  alias Wally.Clerk

  plug :action

  def index(conn, %{"app" => app_name} = _params) do
    Clerk.update(
      %{heroku_app: app_name},
      format_date_time(:calendar.universal_time()),
      "Deployment"
    )
    conn
    |> put_status(200)
    |> text ""
  end

  def index(conn, _params) do
    conn
    |> put_status(422)
    |> text ""
  end

  defp format_date_time({{year, month, day}, {hour, minute, second}}) do
    :io_lib.format(
      "~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B",
      [year, month, day, hour, minute, second]
    )
      |> List.flatten
      |> to_string
  end
end
