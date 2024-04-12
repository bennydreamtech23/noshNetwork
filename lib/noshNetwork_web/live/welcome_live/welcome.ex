defmodule NoshNetworkWeb.WelcomeLive.Welcome do
  use NoshNetworkWeb, :live_view

  def mount(_params, _session, socket) do
    current_name = socket.assigns.current_user.username
    address = socket.assigns.current_user.address

    socket =
      socket
      |> assign(:current_name, current_name)
      |> assign(:address, address)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-2">
      <h1><%= @current_name %> Welcome to Nosh Network</h1>
      <p>Feel at home</p>
      <%= if @address do %>
        <.link href={~p"/users/dashboard"} class="btn-primary">Continue</.link>
      <% else %>
        <.link href={~p"/users/onboarding"} class="btn-primary">Continue</.link>
      <% end %>
    </div>
    """
  end
end
