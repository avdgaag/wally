defmodule Wally.Repo.Migrations.CreateBadge do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add :label, :string, null: false
      add :value, :string, null: false
      add :project_id, references(:projects), null: false

      timestamps
    end

    create index(:badges, [:project_id])
  end
end
