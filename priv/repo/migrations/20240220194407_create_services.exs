defmodule NoshNetwork.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services, primary_key: false) do
      add :service_type, :map
      add :id, :binary_id, primary_key: true
      add :cater_id, references(:caters, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:services, [:cater_id])
  end
end
