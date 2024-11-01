defmodule NoshNetwork.Repo.Migrations.CreateCaters do
  use Ecto.Migration

  def up do
    create table(:caters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :about, :string
      add :social_media, :map
      add :services, {:array, :string}
      add :specialties, {:array, :string}
      add :location, :string
      add :average_rating, :float
      add :availability, :map
      add :business_policies, :map
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:caters, [:user_id])
  end

  def down do
    drop table(:caters)
  end
end
