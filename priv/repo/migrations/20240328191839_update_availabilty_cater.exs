defmodule NoshNetwork.Repo.Migrations.UpdateAvailabiltyCater do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      remove :availability, :map
    end

    alter table(:caters) do
      add :availability, {:map, :jsonb}
    end
  end
end
