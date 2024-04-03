defmodule NoshNetwork.Repo.Migrations.CreateGalleries do
  use Ecto.Migration

  def change do
    create table(:galleries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :gallery_name, :string
      add :is_deleted, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:galleries, [:gallery_name])
  end
end
