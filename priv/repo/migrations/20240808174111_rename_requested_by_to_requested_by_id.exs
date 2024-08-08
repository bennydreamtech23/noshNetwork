defmodule YourApp.Repo.Migrations.AlterQuotationsTable do
  use Ecto.Migration

  def up do
    alter table(:quotations) do
      remove :assigned_to, :string
      remove :requested_by, :string
      add :assigned_by_id, references(:caters, on_delete: :delete_all, type: :binary_id)
      add :requested_by_id, references(:users, on_delete: :delete_all, type: :binary_id)
      # Adding booking_id
      add :booking_id, references(:bookings, on_delete: :delete_all, type: :binary_id)
    end
  end

  def down do
    alter table(:quotations) do
      add :assigned_to, :string
      add :requested_by, :string
      remove :assigned_by_id
      remove :requested_by_id
      # Removing booking_id
      remove :booking_id
    end
  end
end
