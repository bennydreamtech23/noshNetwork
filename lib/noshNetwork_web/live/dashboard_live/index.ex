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
        |> assign(:show_quotation_modal, false)
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
  def handle_event("approve", _params, socket) do
    {:noreply, assign(socket, :show_quotation_modal, true)}
  end
end
