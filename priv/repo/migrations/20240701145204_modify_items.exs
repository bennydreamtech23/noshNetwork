defmodule NoshNetwork.Repo.Migrations.ModifyItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :subtotal, :float
    end
  end
end
