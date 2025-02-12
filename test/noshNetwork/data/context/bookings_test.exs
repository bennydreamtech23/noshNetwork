defmodule NoshNetwork.Data.Context.BookingsTest do
  use NoshNetwork.DataCase

  alias NoshNetwork.Data.Context.Bookings

  describe "reservations" do
    import NoshNetwork.Data.Context.BookingsFixtures

    @invalid_attrs %{event_date: nil, event_duration: nil, event_type: nil, num_guests: nil}

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      assert Bookings.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      assert Bookings.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data creates a reservation" do
      valid_attrs = %{
        event_date: ~N[2024-04-11 20:53:00],
        event_duration: 42,
        event_type: "some event_type",
        num_guests: 42
      }

      assert {:ok, %Reservation{} = reservation} = Bookings.create_reservation(valid_attrs)
      assert reservation.event_date == ~N[2024-04-11 20:53:00]
      assert reservation.event_duration == 42
      assert reservation.event_type == "some event_type"
      assert reservation.num_guests == 42
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookings.create_reservation(@invalid_attrs)
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()

      update_attrs = %{
        event_date: ~N[2024-04-12 20:53:00],
        event_duration: 43,
        event_type: "some updated event_type",
        num_guests: 43
      }

      assert {:ok, %Reservation{} = reservation} =
               Bookings.update_reservation(reservation, update_attrs)

      assert reservation.event_date == ~N[2024-04-12 20:53:00]
      assert reservation.event_duration == 43
      assert reservation.event_type == "some updated event_type"
      assert reservation.num_guests == 43
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Bookings.update_reservation(reservation, @invalid_attrs)

      assert reservation == Bookings.get_reservation!(reservation.id)
    end

    test "delete_reservation/1 deletes the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{}} = Bookings.delete_reservation(reservation)
      assert_raise Ecto.NoResultsError, fn -> Bookings.get_reservation!(reservation.id) end
    end

    test "change_reservation/1 returns a reservation changeset" do
      reservation = reservation_fixture()
      assert %Ecto.Changeset{} = Bookings.change_reservation(reservation)
    end
  end

  describe "bookings" do
    alias NoshNetwork.Data.Context.Bookings.Booking

    import NoshNetwork.Data.Context.BookingsFixtures

    @invalid_attrs %{event_date: nil, event_duration: nil, event_type: nil, num_guests: nil}

    test "list_bookings/0 returns all bookings" do
      booking = booking_fixture()
      assert Bookings.list_bookings() == [booking]
    end

    test "get_booking!/1 returns the booking with given id" do
      booking = booking_fixture()
      assert Bookings.get_booking!(booking.id) == booking
    end

    test "create_booking/1 with valid data creates a booking" do
      valid_attrs = %{
        event_date: ~N[2024-04-11 22:23:00],
        event_duration: 42,
        event_type: "some event_type",
        num_guests: 42
      }

      assert {:ok, %Booking{} = booking} = Bookings.create_booking(valid_attrs)
      assert booking.event_date == ~N[2024-04-11 22:23:00]
      assert booking.event_duration == 42
      assert booking.event_type == "some event_type"
      assert booking.num_guests == 42
    end

    test "create_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookings.create_booking(@invalid_attrs)
    end

    test "update_booking/2 with valid data updates the booking" do
      booking = booking_fixture()

      update_attrs = %{
        event_date: ~N[2024-04-12 22:23:00],
        event_duration: 43,
        event_type: "some updated event_type",
        num_guests: 43
      }

      assert {:ok, %Booking{} = booking} = Bookings.update_booking(booking, update_attrs)
      assert booking.event_date == ~N[2024-04-12 22:23:00]
      assert booking.event_duration == 43
      assert booking.event_type == "some updated event_type"
      assert booking.num_guests == 43
    end

    test "update_booking/2 with invalid data returns error changeset" do
      booking = booking_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookings.update_booking(booking, @invalid_attrs)
      assert booking == Bookings.get_booking!(booking.id)
    end

    test "delete_booking/1 deletes the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{}} = Bookings.delete_booking(booking)
      assert_raise Ecto.NoResultsError, fn -> Bookings.get_booking!(booking.id) end
    end

    test "change_booking/1 returns a booking changeset" do
      booking = booking_fixture()
      assert %Ecto.Changeset{} = Bookings.change_booking(booking)
    end
  end
end
