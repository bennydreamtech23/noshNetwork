defmodule NoshNetwork.Data.Schema.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.Cater

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "services" do
    field :service_type, :map
    belongs_to :cater, Cater
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [])
    |> validate_required([])
  end
end
