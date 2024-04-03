defmodule NoshNetwork.Repo.Migrations.ChangeGallrtyCaters do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      # Drop the existing column
      remove(:gallery, {:array, :string}, default: [])
    end

    alter table(:caters) do
      # Add the column with the desired data type and options
      add(:gallery, {:array, :string}, default: [], null: false)
    end
  end
end
