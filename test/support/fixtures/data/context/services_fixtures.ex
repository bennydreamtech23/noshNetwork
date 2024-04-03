defmodule NoshNetwork.Data.Context.ServicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Data.Context.Services` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(%{})
      |> NoshNetwork.Data.Context.Services.create_service()

    service
  end
end
