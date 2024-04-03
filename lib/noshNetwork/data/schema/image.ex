defmodule NoshNetwork.Data.Schema.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Noshnetwrok.Repo
  alias NoshNetwork.Data.Schema.Image
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "images" do
    field :image, :string
    field :title, :string
    field :type, :string
    belongs_to :user, NoshNetwork.Schema.User, foreign_key: :user_id, type: :binary_id

    belongs_to :galleries, NoshNetwork.Schema.Gallery, foreign_key: :gallery_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gallery, attrs) do
    gallery
    |> cast(attrs, [:image, :type, :user_id, :gallery_id, :title])
    |> validate_required([:image, :user_id])
  end

  # def changeset(image, attrs) do
  #   image
  #   |> cast(attrs, [:image, :type, :user_id, :title])
  #   |> validate_required([:image, :user_id], message: "This field is required")
  # end

  def create_image(attrs) do
    %Image{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_image(id), do: Repo.get(Image, id)

  def list_images() do
    Image
    |> Repo.all()
  end

  # def list_images_by_gallery_id(gallery_id) do
  #   from(u in Image, where: u.gallery_id == ^gallery_id)
  #   |> Repo.all()
  # end
end
