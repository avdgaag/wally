defmodule Wally.Project do
  @moduledoc """
  Represents a project on the status wall that has a status for various aspects.
  """

  defstruct id: nil, name: nil, api_token: nil

  @doc """
  Build a new Wally.Project struct from a given name. This will automatically
  generate a new secure token for the new project.
  """
  def new(name) do
    %Wally.Project{name: name, api_token: Wally.SecureToken.generate}
  end
end
