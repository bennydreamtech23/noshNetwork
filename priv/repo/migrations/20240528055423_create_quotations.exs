defmodule NoshNetwork.Repo.Migrations.CreateQuotations do
  use Ecto.Migration

  def change do
    create table(:quotations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :reference_id, :string
      add :subtotal, :string
      add :fee, :string
      add :total, :string
      add :note, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :cater_id, references(:caters, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end
