defmodule NoshNetwork.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        image: "some image",
        title: "some title",
        type: "some type"
      })
      |> NoshNetwork.Images.create_image()

    image
  end
end
