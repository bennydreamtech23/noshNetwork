defmodule NoshNetwork.Repo.Migrations.AlterQuotationTotal do
  use Ecto.Migration

  def change do
    alter table(:quotations) do
      # Add the column with the desired data type and options
      remove :total, :string
      add :total, :float
    end
  end
end
