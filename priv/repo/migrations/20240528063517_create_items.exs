defmodule NoshNetwork.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :price, :float
      add :quantity, :integer
      add :subtotal, :float
      add :quotation_id, references(:quotations, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:quotation_id])
  end
end
