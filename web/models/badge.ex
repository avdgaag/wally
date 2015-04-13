defmodule Wally.Badge do
  use Wally.Web, :model

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
