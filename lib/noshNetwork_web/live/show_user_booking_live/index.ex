defmodule NoshNetworkWeb.ShowUserBookingLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Bookings

  def mount(_session, _params, socket) do
    user_id = socket.assigns.current_user.id

    user_booking = Bookings.get_bookings_by_user_id(user_id)

    socket =
      socket
      |> assign(:user_booking, user_booking)

    {:ok, socket}
  end
end
