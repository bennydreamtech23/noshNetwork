defmodule NoshNetwork.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :image, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :gallery_id, references(:gallery_id, on_delete: :delete_all, type: :binary_id)
      add :belong_to_gallery, :string
      timestamps(type: :utc_datetime)
    end

    create index(:images, [:user_id])
  end
end
