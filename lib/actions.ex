defmodule Wally.Actions do
  import Wally.Endpoint, only: [broadcast: 3]

  @moduledoc """
  Broadcast redux actions to all subscribed listeners.
  """

  @doc "Announce a new incoming event for a project"
  def new_event(event) do
    broadcast "actions", "event:new", %{type: "NEW_EVENT", event: event}
  end
end
