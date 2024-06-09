defmodule NoshNetwork.Data.Schema.Quotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "quotations" do
    field :reference_id, :string
    field :subtotal, :string
    field :fee, :string
    field :total, :string
    field :note, :string

    belongs_to :cater, NoshNetwork.Data.Schema.Cater, type: :binary_id
    belongs_to :user, NoshNetwork.Data.Schema.User, type: :binary_id

    has_many :items, Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quotation, attrs) do
    quotation
    |> cast(attrs, [:reference_id, :subtotal, :fee, :total, :note, :cater_id, :user_id])
    |> validate_required([:reference_id, :subtotal, :fee, :total, :note, :cater_id, :user_id])
  end
end
