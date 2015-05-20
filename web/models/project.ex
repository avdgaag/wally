defmodule Wally.Project do
  use Wally.Web, :model

  @moduledoc """
  A project is a line on the status board and can have any number of badges,
  which indicate a metric or status of some aspect of the project.
  """

  schema "projects" do
    field :title, :string
    field :settings, Wally.Jsonb.Type
    has_many :badges, Wally.Badge

    timestamps
  end

  @required_fields ~w(title settings)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Query for all records in chronological order of creation.
  """
  def chronologically do
    from project in Wally.Project,
      order_by: [project.inserted_at, project.id]
  end

  @doc """
  Query for all records whose settings match a given subset of settings. The
  comparison will be made as JSON.

  For example, if a records contains these settings:

      { "heroku_app": "foo", "github_id": 1234 }

  Then these queries would find them:

      Project.by_settings(%{heroku_app: "foo"})
      Project.by_settings(%{github_id: 1234})
      Project.by_settings(%{heroku_app: "foo", github_id: 1234})

  """
  def by_settings(settings) do
    # Since we use `fragment` below, we need to dump our value ourselves,
    # rather than Ecto doing it for us.
    {:ok, json} = Wally.Jsonb.Type.dump(settings)

    from project in Wally.Project,
      where: fragment("? @> ?::jsonb", project.settings, ^json)
  end
end
