defmodule Wally.NotificationsChannel do
  use Phoenix.Channel

  @moduledoc """
  Websockets channel to hand out notifications to connected clients.
  """

  def join("notifications", %{"api_token" => api_token}, socket) do
    if Wally.User.find_by_token(api_token) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
