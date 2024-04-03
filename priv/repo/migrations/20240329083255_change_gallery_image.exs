defmodule NoshNetwork.Repo.Migrations.ChangeGalleryImage do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      remove(:gallery, {:array, :string}, default: [])
    end

    alter table(:caters) do
      add :photo, :string
    end
  end
end
