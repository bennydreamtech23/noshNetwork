defmodule NoshNetwork.Repo.Migrations.AlterBookingTable do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      # Drop the existing column
      remove(:service_type, :array)
    end

    alter table(:bookings) do
      # Add the column with the desired data type and options
      add(:service_type, {:array, :string}, default: [])
    end
  end
end
