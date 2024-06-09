defmodule NoshNetwork.Data.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.Quotation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :description, :string
    field :name, :string
    field :price, :string
    field :quantity, :integer
    field :subtotal, :string

    belongs_to :quotation, Quotation, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :quantity, :subtotal, :quotation_id])
    |> validate_required([:name, :description, :price, :quantity])
  end
end
