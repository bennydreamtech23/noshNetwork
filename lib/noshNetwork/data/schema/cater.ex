defmodule NoshNetwork.Data.Schema.Cater do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.Service

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "caters" do
    field :about, :string
    field :gallery, :map
    field :social_media, :map
    field :specialties, {:array, :string}
    field :average_rating, :float
    field :availability, :map
    field :business_policies, :map
    field :user_id, :binary_id
    has_many :services, Service
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cater, attrs) do
    cater
    |> cast(attrs, [:about, :gallery, :social_media])
    |> validate_required([:about])
  end
end
