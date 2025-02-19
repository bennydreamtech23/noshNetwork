defmodule NoshNetworkWeb.ShowUserBookingLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Bookings
  alias NoshNetwork.Data.Context.Caters

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket, label: "socket available")
    current_user = socket.assigns.current_user

    socket =
      if current_user.role == "cater" do
        # Fetch cater information based on the current user
        cater = Caters.get_cater_by_user_id(current_user.id)
        cater_id = cater.id
        user_booking = if cater, do: Bookings.get_bookings_by_cater_id(cater.id), else: []

        socket
        |> assign(:current_user, current_user)
        |> assign(:user_booking, user_booking)
        |> assign(:cater_id, cater_id)
        |> assign(:booking_id, nil)
        |> assign(:booking_details, nil)
        |> assign(:show_quotation, false)
        |> assign(:show_quotation_modal, false)
        |> assign(:show_more, false)
        |> assign(:caters, [])
      else
        # For non-cater users, fetch all caters
        user_id = socket.assigns.current_user.id
        current_user = socket.assigns.current_user
        user_booking = Bookings.get_bookings_by_user_id(user_id)

        socket
        |> assign(:user_booking, user_booking)
        |> assign(:booking_id, nil)
        |> assign(:show_more, false)
        |> assign(:show_quotation_modal, false)
        |> assign(:show_quotation, false)
        |> assign(:current_user, current_user)
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("view_quotation", %{"id" => id}, socket) do
    {
      :noreply,
      socket
      |> assign(:booking_id, id)
      |> assign(:show_quotation, true)
    }
  end

  @impl true
  def handle_event("show_more", %{"id" => id}, socket) do
    {
      :noreply,
      socket
      |> assign(:booking_id, id)
      |> assign(:show_more, true)
    }
  end


  @impl true
  ##### approve functionality
  def handle_event("approve", %{"id" => id}, socket) do
    bookings = socket.assigns[:user_booking]

    booking =
      Enum.find(
        bookings,
        fn booking ->
          booking.id == id
        end
      )

    status = "approved"

    Bookings.update_booking_status(booking, status)

    {
      :noreply,
      socket
      |> assign(:booking_details, booking)
      |> assign(:show_quotation_modal, true)
    }
  end
end
