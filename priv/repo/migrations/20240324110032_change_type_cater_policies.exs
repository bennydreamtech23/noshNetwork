defmodule NoshNetwork.Repo.Migrations.ChangeTypeCaterPolicies do
  use Ecto.Migration

  def change do
    alter table(:caters) do
      modify(:business_policies, :string)
    end
  end
end
