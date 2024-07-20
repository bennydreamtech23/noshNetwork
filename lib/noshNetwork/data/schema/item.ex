defmodule NoshNetwork.Data.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.{Quotation, Cater}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :quantity, :string
    field :subtotal, :float
    belongs_to :cater, Cater, foreign_key: :cater_id
    belongs_to :quotation, Quotation, foreign_key: :quotation_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :quantity, :subtotal, :quotation_id, :cater_id])
    |> validate_required([:name, :price, :quantity])
  end
end
