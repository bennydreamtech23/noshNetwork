defmodule NoshNetwork.Repo.Migrations.AddIsVerifiedAndIsActiveToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_verified, :boolean, default: false, null: false
      add :is_active, :boolean, default: false, null: false
    end
  end
end
