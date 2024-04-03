defmodule NoshNetwork.Repo.Migrations.UpdateSocialMediaType do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      remove :social_media, :map
    end

    alter table(:caters) do
      add :social_media, {:map, :jsonb}
    end
  end
end
