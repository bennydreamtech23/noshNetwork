defmodule NoshNetwork.Repo.Migrations.DropServicesFromCaters do
  use Ecto.Migration

  def change do
alter table(:caters) do
      remove :services
      remove :location
    end
  end
end
