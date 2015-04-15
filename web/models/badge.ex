defmodule Wally.Badge do
  use Wally.Web, :model

  @moduledoc """
  A badge represents a status or metric about a project, to which it belongs.
  It simply presents a string value to be displayed (maybe intelligently) on
  the client. Badges are created and updates using incoming web hooks.
  """

  schema "badges" do
    field :label, :string
    field :value, :string
    belongs_to :project, Wally.Project

    timestamps
  end

  @required_fields ~w(label value project_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
