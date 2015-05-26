defmodule Wally.Repo.Migrations.CreateApiToken do
  use Ecto.Migration

  def change do
    create table(:api_tokens) do
      add :description, :string, null: false
      add :token, :string, null: false
      timestamps
    end
    create index(:api_tokens, [:token], unique: true)
  end
end
