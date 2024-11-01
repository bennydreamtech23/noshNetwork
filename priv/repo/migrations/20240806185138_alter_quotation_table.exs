defmodule NoshNetwork.Repo.Migrations.AlterQuotationTable do
  use Ecto.Migration

  def up do
    alter table(:quotations) do
      # remove :subtotal
      remove :fee
      add :status, :string
      add :quotation_date, :string, null: false
      add :due_date, :string, null: false
      add :amount_paid, :float
      add :fee, :float
    end
  end

  def down do
    alter table(:quotations) do
      # remove :subtotal, :string
      remove :status
      remove :quotation_date
      remove :due_date
      remove :amount_paid
      remove :total
      remove :fee, :string
    end
  end
end
