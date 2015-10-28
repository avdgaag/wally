defmodule Wally.AuthController do
  use Wally.Web, :controller
  import Wally.Session, only: [sign_in_user: 2]

  @user_url "https://www.googleapis.com/plus/v1/people/me/openIdConnect"

  def index(conn, %{"provider" => "google"}) do
    conn
    |> redirect(external: Google.authorize_url!(scope: "email profile"))
  end

  def callback(conn, %{"provider" => "google", "code" => code}) do
    token = Google.get_token!(code: code)
    user = User.from_google_oauth(OAuth2.AccessToken.get!(token, @user_url))
    sign_in_user(conn, user)
  end
end
