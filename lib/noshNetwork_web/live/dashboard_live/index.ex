defmodule NoshNetworkWeb.DashboardLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    caters = Users.get_all_caters()

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:caters, caters)

    {:ok, socket}
  end
end
