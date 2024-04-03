defmodule NoshNetwork.Repo.Migrations.ChangeGalleryCaters do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      modify(:social_media, :string)
    end
  end
end
