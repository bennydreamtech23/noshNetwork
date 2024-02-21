defmodule NoshNetwork.Repo.Migrations.DropCatersFromServices do
  use Ecto.Migration

  def change do
    alter table(:services) do
      remove :cater_id
    end
  end
end
