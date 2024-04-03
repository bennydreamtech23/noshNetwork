defmodule NoshNetwork.Data.Context.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias NoshNetwork.Repo

  alias NoshNetwork.Data.Schema.Image

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images(search_string \\ nil) do
    search_string = search_string && String.downcase(search_string)

    query =
      from u in Image,
        order_by: [desc: u.inserted_at]

    query =
      if search_string do
        query
        |> where([u], fragment("? ilike ?", u.title, ^"%#{search_string}%"))
      else
        query
      end

    query
    |> Repo.all()
  end

  def get_image!(id), do: Repo.get!(Image, id)

  def get_image_by_name(image_name), do: Repo.get_by(Image, title: image_name)

  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  def change_image(%Image{} = image, attrs \\ %{}) do
    Image.changeset(image, attrs)
  end

  def list_images_by_gallery_id(gallery_id, search_string \\ nil) do
    search_string = search_string && String.downcase(search_string)

    query = from(u in Image, where: u.gallery_id == ^gallery_id)

    query =
      if search_string do
        query
        |> where([u], fragment("? ilike ?", u.title, ^"%#{search_string}%"))
      else
        query
      end

    query
    |> Repo.all()
  end
end
