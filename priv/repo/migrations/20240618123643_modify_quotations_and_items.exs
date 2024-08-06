defmodule NoshNetwork.Repo.Migrations.ModifyQuotationsAndItems do
  use Ecto.Migration

  def change do
    alter table(:quotations) do
      remove :user_id
      remove :cater_id

      add :requested_by, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :assigned_to, references(:caters, on_delete: :delete_all, type: :binary_id), null: false
    end

    alter table(:items) do
      remove :price
      remove :quantity
      remove :subtotal

      add :price, :float
      add :quantity, :string
      add :cater_id, references(:caters, on_delete: :delete_all, type: :binary_id), null: false
    end
  end
end
