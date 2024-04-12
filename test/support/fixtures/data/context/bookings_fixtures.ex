defmodule NoshNetwork.Data.Context.BookingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoshNetwork.Data.Context.Bookings` context.
  """

  @doc """
  Generate a reservation.
  """
  def reservation_fixture(attrs \\ %{}) do
    {:ok, reservation} =
      attrs
      |> Enum.into(%{
        event_date: ~N[2024-04-11 20:53:00],
        event_duration: 42,
        event_type: "some event_type",
        num_guests: 42
      })
      |> NoshNetwork.Data.Context.Bookings.create_reservation()

    reservation
  end

  @doc """
  Generate a booking.
  """
  def booking_fixture(attrs \\ %{}) do
    {:ok, booking} =
      attrs
      |> Enum.into(%{
        event_date: ~N[2024-04-11 22:23:00],
        event_duration: 42,
        event_type: "some event_type",
        num_guests: 42
      })
      |> NoshNetwork.Data.Context.Bookings.create_booking()

    booking
  end
end
