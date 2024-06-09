defmodule NoshNetwork.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "some price",
        quantity: 42,
        subtotal: "some subtotal"
      })
      |> NoshNetwork.Items.create_item()

    item
  end
end
