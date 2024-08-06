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

    belongs_to :assigned_to, NoshNetwork.Data.Schema.Cater, foreign_key: :cater_id
    belongs_to :requested_by, NoshNetwork.Data.Schema.User, foreign_key: :user_id

    has_many :items, Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quotation, attrs) do
    quotation
    |> cast(attrs, [:reference_id, :subtotal, :fee, :total, :note, :assigned_to, :requested_by])
    |> validate_required([
      :reference_id,
      :subtotal,
      :fee,
      :total,
      :note,
      :assigned_to,
      :requested_by
    ])
  end
end
