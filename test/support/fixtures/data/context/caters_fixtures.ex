defmodule NoshNetwork.Data.Context.CatersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Data.Context.Caters` context.
  """

  @doc """
  Generate a cater.
  """
  def cater_fixture(attrs \\ %{}) do
    {:ok, cater} =
      attrs
      |> Enum.into(%{
        about: "some about",
        gallery: %{},
        social_media: %{}
      })
      |> NoshNetwork.Data.Context.Caters.create_cater()

    cater
  end
end
