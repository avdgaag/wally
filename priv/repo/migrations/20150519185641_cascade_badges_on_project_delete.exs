defmodule Wally.Repo.Migrations.CascadeBadgesOnProjectDelete do
  use Ecto.Migration

  def change do
    execute """
    ALTER TABLE badges
    DROP CONSTRAINT badges_project_id_fkey,
    ADD CONSTRAINT badges_project_id_fkey
    FOREIGN KEY (project_id)
    REFERENCES projects(id)
    ON DELETE CASCADE;
    """
  end
end
