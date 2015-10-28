defmodule Wally.Project do
  @moduledoc """
  Represents a project on the status wall that has a status for various aspects.
  """

  defstruct id: nil, name: nil, heroku_app: nil, api_token: nil
end
