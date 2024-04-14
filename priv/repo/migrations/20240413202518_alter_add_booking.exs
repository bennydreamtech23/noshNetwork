defmodule NoshNetwork.Repo.Migrations.AlterAddBooking do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      # Add the column with the desired data type and options
      add(:dietary_restriction, {:array, :string}, default: [])
      add(:specific_dishes, {:array, :string}, default: [])
    end
  end
end
