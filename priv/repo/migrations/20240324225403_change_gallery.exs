defmodule NoshNetwork.Repo.Migrations.ChangeGallery do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      # Drop the existing column
      remove(:gallery, :map)
    end

    alter table(:caters) do
      # Add the column with the desired data type and options
      add(:gallery, {:array, :string}, default: [])
    end
  end
end
