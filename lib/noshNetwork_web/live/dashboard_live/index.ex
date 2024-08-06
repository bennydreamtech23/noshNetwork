defmodule NoshNetworkWeb.DashboardLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users
  alias NoshNetwork.Data.Context.{Bookings, Caters}

  @impl true
  def mount(params, _session, socket) do
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
        |> assign(:show_quotation_modal, false)
        |> assign(:show_more, false)
        |> assign(:caters, [])
      else
        # For non-cater users, fetch all caters
        caters = Users.get_all_caters()

        socket
        |> assign(:current_user, current_user)
        |> assign(:caters, caters)
        |> assign(:user_booking, [])
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("cater_show", %{"id" => id}, socket) do
    IO.inspect(id, label: "id of what is happening here")

    socket =
      socket
      |> push_navigate(to: ~p"/users/cater?#{[id: id]}")

    {:noreply, socket}
  end

  @impl true
  def handle_event("booking_action", %{"id" => id}, socket) do
    socket =
      socket
      |> push_navigate(to: ~p"/users/booking?#{[id: id]}")

    {:noreply, socket}
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

  def handle_event("show_more", %{"id" => id}, socket) do
    {
      :noreply,
      socket
      |> assign(:booking_id, id)
      |> assign(:show_more, true)
    }
  end
end
