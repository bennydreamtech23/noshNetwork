defmodule NoshNetworkWeb.DashboardLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    caters = Users.get_all_caters()

    links = [
      %{label: "Dashboard", path: "/users/dashboard"},
      %{label: "Booking", path: "/users/booking"},
      %{label: "Setting", path: "/users/settings"}
    ]

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:link, links)
      |> assign(:caters, caters)
      |> assign(current_path: "/users/dashboard")

    {:ok, socket}
  end

  @impl true
  def handle_event("get_caterer_details", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user

    if current_user.is_verified and current_user.is_active do
      socket =
        socket
        |> push_navigate(to: ~p"/users/cater?#{[id: id]}")

      {:noreply, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Please complete the onboarding process to proceed with booking.")
        |> push_navigate(to: ~p"/users/onboarding")

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("booking_action", %{"cater_id" => id}, socket) do
    current_user = socket.assigns.current_user

    if current_user.is_verified and current_user.is_active do
      socket =
        socket
        |> push_navigate(to: ~p"/users/create_booking?#{[id: id]}")

      {:noreply, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Please complete the onboarding process to proceed with booking.")
        |> push_navigate(to: ~p"/users/onboarding")

      {:noreply, socket}
    end
  end
end
