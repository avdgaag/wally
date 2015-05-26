defmodule Wally.ApiTokenController do
  use Wally.Web, :controller

  alias Wally.ApiToken

  plug :scrub_params, "api_token" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    api_tokens = Repo.all(ApiToken)
    render(conn, "index.html", api_tokens: api_tokens)
  end

  def new(conn, _params) do
    changeset = ApiToken.changeset(%ApiToken{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api_token" => api_token_params}) do
    changeset = ApiToken.changeset(%ApiToken{}, api_token_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "ApiToken created successfully.")
      |> redirect(to: api_token_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    api_token = Repo.get(ApiToken, id)
    Repo.delete(api_token)

    conn
    |> put_flash(:info, "ApiToken deleted successfully.")
    |> redirect(to: api_token_path(conn, :index))
  end
end
