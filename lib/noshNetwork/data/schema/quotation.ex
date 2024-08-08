defmodule NoshNetwork.Data.Schema.Quotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias NoshNetwork.Data.Schema.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
    reference_id
   requested_by_id
   total
   booking_id
  |a

  @optional_fields ~w|
  status
fee
   assigned_by_id
   quotation_date
    due_date
   note
    amount_paid
  |a

  @all_fields @required_fields ++ @optional_fields

  schema "quotations" do
    field :reference_id, :string
    field :fee, :float
    field :total, :float
    field :amount_paid, :float
    field :note, :string
    field :status, :string
    field :due_date, :string
    field :quotation_date, :string

    belongs_to :assigned_by, NoshNetwork.Data.Schema.Cater, foreign_key: :assigned_by_id
    belongs_to :requested_by, NoshNetwork.Data.Schema.User, foreign_key: :requested_by_id
    belongs_to :booking, NoshNetwork.Data.Schema.Booking, foreign_key: :booking_id

    has_many :items, Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quotation, attrs) do
    quotation
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
