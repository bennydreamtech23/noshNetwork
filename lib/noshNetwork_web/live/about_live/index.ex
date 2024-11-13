defmodule NoshNetworkWeb.AboutLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users

  def mount(_params, session, socket) do

    socket =
      socket
      |> assign(:current_user, Users.get_user_by_session_token(session["user_token"]))


    {:ok, socket}
  end


end
