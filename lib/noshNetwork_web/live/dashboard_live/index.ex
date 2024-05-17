defmodule NoshNetworkWeb.DashboardLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users
  alias NoshNetwork.Data.Context.{Bookings, Caters}

  @impl true
  def mount(%{"cater" => _} = params, session, socket) do
    current_user = socket.assigns.current_user

    cater_id = Caters.get_cater_by_user_id(current_user.id)
    user_booking = Bookings.get_bookings_by_cater_id(cater_id.id)

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:user_booking, user_booking)

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    caters = Users.get_all_caters()

    {:ok, socket |> assign(:current_user, current_user) |> assign(:caters, caters)}
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
end
