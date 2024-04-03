defmodule NoshNetwork.GallerysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Gallerys` context.
  """

  @doc """
  Generate a gallery.
  """
  def gallery_fixture(attrs \\ %{}) do
    {:ok, gallery} =
      attrs
      |> Enum.into(%{
        gallery_name: "some gallery_name",
        is_deleted: true
      })
      |> NoshNetwork.Gallerys.create_gallery()

    gallery
  end
end
