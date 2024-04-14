defmodule NoshNetworkWeb.DashboardLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users
  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    caters = Users.get_all_caters()

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:caters, caters)

    {:ok, socket}
  end

  @impl true
  def handle_event("cater_show", %{"id" => id}, socket) do
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
