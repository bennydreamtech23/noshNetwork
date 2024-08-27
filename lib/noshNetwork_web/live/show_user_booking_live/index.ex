defmodule NoshNetworkWeb.ShowUserBookingLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Bookings

  def mount(_session, _params, socket) do
    user_id = socket.assigns.current_user.id
    current_user = socket.assigns.current_user
    user_booking = Bookings.get_bookings_by_user_id(user_id)

    socket =
      socket
      |> assign(:user_booking, user_booking)
      |> assign(:booking_id, nil)
      |> assign(:show_quotation, false)
      |> assign(:current_user, current_user)

    {:ok, socket}
  end

  def handle_event("view_quotation", %{"id" => id}, socket) do
    {
      :noreply,
      socket
      |> assign(:booking_id, id)
      |> assign(:show_quotation, true)
    }
  end
end
