defmodule Wally.NotificationsChannel do
  use Phoenix.Channel

  def join("notifications", _auth_msg, socket) do
    {:ok, socket}
  end
end
