defmodule NoshNetworkWeb.CaterLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users

  def mount(%{"id" => id}, _session, socket) do
    cater_details = Users.get_cater(id)

    {:ok, assign(socket, cater_details: cater_details)}
  end

  @impl true
  def handle_event("booking_action", %{"id" => id}, socket) do
    socket =
      socket
      |> push_navigate(to: ~p"/users/booking?#{[id: id]}")

    {:noreply, socket}
  end
end
