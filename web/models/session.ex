defmodule Wally.Session do
  import Plug.Conn,
         only: [put_session: 3, delete_session: 2, get_session: 2, halt: 1, fetch_query_params: 1]

  @session_key :user_id

  def login(conn, %Wally.User{id: id}) do
    put_session(conn, @session_key, id)
  end

  def logout(conn) do
    delete_session(conn, @session_key)
  end

  def current_user(conn) do
    id = get_session(conn, @session_key) || 0
    Wally.User.find_by_id(id)
  end

  def logged_in?(conn) do
    case current_user(conn) do
      nil -> false
      _   -> true
    end
  end

  def current_token(conn) do
    api_token = fetch_query_params(conn).params["api_token"]
    Wally.ApiToken.find_by_token(api_token)
  end

  def token_authenticated?(conn) do
    case current_token(conn) do
      nil -> false
      _   -> true
    end
  end
end
