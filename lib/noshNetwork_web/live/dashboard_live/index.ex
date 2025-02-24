defmodule NoshNetworkWeb.DashboardLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users
  alias NoshNetworkWeb.Router.Helpers, as: Routes


  @moduledoc """
  LiveView module for the dashboard index page.
  """

  @impl true
  def mount(params, _session, socket) do
    IO.inspect(Users.paginate_caters(params))
    current_user = socket.assigns.current_user
    # caters = Users.get_all_caters()
   caters = Users.paginate_caters(params).entries
    total_pages = Users.paginate_caters(params).total_pages
    page_number = Users.paginate_caters(params).page_number
    total_entries = Users.paginate_caters(params).total_entries


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
      |> assign(:total_pages, total_pages)
      |> assign(:page_number, page_number)
  |> assign(:total_entries, total_entries)

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


  def handle_params(params, _url, socket) do
    caters = Users.paginate_caters(params).entries
    total_pages = Users.paginate_caters(params).total_pages
    page_number = Users.paginate_caters(params).page_number
    total_entries = Users.paginate_caters(params).total_entries


    {:noreply,
     socket
     |> assign(:caters, caters)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> apply_action(socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :index, _params) do
    socket
  end


end
