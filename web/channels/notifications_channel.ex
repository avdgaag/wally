defmodule Wally.NotificationsChannel do
  use Phoenix.Channel

  @moduledoc """
  Websockets channel to hand out notifications to connected clients.
  """

  def join("notifications", _auth_msg, socket) do
    {:ok, socket}
  end
end
