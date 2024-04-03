defmodule NoshNetwork.Data.Schema.Cater do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.Service
  alias NoshNetwork.Data.Schema.User
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w|
about
user_id
  business_policies
    specialties
  |a

  @optional_fields ~w|

social_media
average_rating
  availability
      photo
  |a

  @all_fields @required_fields ++ @optional_fields
  schema "caters" do
    field :about, :string
    field :photo, :string
    field :social_media, {:map, :string}
    field :specialties, {:array, :string}
    field :average_rating, :float
    field :availability, {:map, :string}
    field :business_policies, :string
    # field :user_id, :binary_id

    belongs_to :users, User, foreign_key: :user_id, type: :binary_id
    has_many :services, Service
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cater, attrs) do
    cater
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields, message: "This field is required")
  end
end
