defmodule NoshNetworkWeb.HomepageLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users

  def mount(_params, session, socket) do
    cusine = "nigeria"

    socket =
      socket
      |> assign(:current_user, Users.get_user_by_session_token(session["user_token"]))
      |> assign(:cusine, cusine)

    {:ok, socket}
  end

  def handle_event("update_cusine", params, socket) do
    {:noreply, socket |> assign(:cusine, params["cusine"])}
  end
end
