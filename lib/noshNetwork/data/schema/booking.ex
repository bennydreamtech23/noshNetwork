defmodule NoshNetwork.Data.Schema.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.User
  alias NoshNetwork.Data.Schema.Cater
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
user_id
  cater_id
  status
  event_type
  event_duration
  event_date
  num_guests
  venue_location
  budget
  |a

  @optional_fields ~w|
cusine_preference
service_type
additional_service
indoor_outdoor
budget_constraints
special_request
specific_dishes
dietary_restriction
  |a
  @all_fields @required_fields ++ @optional_fields
  schema "bookings" do
    field :event_date, :naive_datetime
    field :event_duration, :integer
    field :event_type, :string
    field :num_guests, :integer
    field :cusine_preference, {:array, :string}
    field :service_type, {:array, :string}
    field :dietary_restriction, {:array, :string}
    field :specific_dishes, {:array, :string}
    field :additional_service, :string
    field :venue_location, :string
    field :indoor_outdoor, :boolean, default: false
    field :budget, :string
    field :budget_constraints, :string
    field :special_request, :string
    field :status, :string
    belongs_to :users, User, foreign_key: :user_id, type: :binary_id
    belongs_to :caters, Cater, foreign_key: :cater_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields, message: "This field is required")
  end

  def status_changeset(booking, attrs) do
    booking
    # Note that [:status] is a list containing the :status atom
    |> cast(attrs, [:status])
    |> validate_required([:status], message: "This field is required")
  end
end
