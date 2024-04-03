defmodule NoshNetwork.Data.Schema.Gallery do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "galleries" do
    field :gallery_name, :string
    field :is_deleted, :boolean, default: false

    has_many :images, NoshNetwork.Data.Schema.Image, on_delete: :delete_all
    belongs_to :user, NoshNetwork.Schema.User, foreign_key: :user_id, type: :binary_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gallery, attrs) do
    gallery
    |> cast(attrs, [:gallery_name, :user_id])
    |> validate_required([:gallery_name, :user_id])
  end
end
