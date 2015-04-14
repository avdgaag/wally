defmodule Wally.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string, null: false
      add :settings, :jsonb

      timestamps default: "now()"
    end

    create index(:projects, [:settings], using: :gin)
  end
end
