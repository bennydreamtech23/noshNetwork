defmodule NoshNetworkWeb.WelcomeLive.Welcome do
  use NoshNetworkWeb, :live_view

  def mount(_params, _session, socket) do
    current_name = socket.assigns.current_user.username

    socket =
      socket
      |> assign(:current_name, current_name)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-2">
      <h1><%= @current_name %> Welcome to Nosh Network</h1>
      <p>Feel at home</p>
      <.link href={~p"/users/onboarding"} class="btn-primary">Continue</.link>
    </div>
    """
  end
end
