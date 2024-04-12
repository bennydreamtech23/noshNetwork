defmodule NoshNetwork.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :event_type, :string
      add :event_date, :naive_datetime
      add :event_duration, :integer
      add :num_guests, :integer
      add :cusine_preference, {:array, :string}
      add :service_type, {:array, :string}
      add :additional_service, :string
      add :venue_location, :string
      add :indoor_outdoor, :boolean, default: false
      add :budget, :string
      add :budget_constraints, :string
      add :special_request, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :cater_id, references(:caters, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:bookings, [:user_id])
    create index(:bookings, [:cater_id])
  end
end
