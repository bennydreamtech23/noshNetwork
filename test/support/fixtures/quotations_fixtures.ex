defmodule NoshNetwork.QuotationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Quotations` context.
  """

  @doc """
  Generate a quotation.
  """
  def quotation_fixture(attrs \\ %{}) do
    {:ok, quotation} =
      attrs
      |> Enum.into(%{
        fee: "some fee",
        note: "some note",
        reference_id: "some reference_id",
        subtotal: "some subtotal",
        total: "some total"
      })
      |> NoshNetwork.Quotations.create_quotation()

    quotation
  end
end
