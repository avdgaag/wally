defmodule Wally.ActionChannel do
  use Phoenix.Channel

  def join(_, _, socket) do
    {:ok, socket}
  end
end
