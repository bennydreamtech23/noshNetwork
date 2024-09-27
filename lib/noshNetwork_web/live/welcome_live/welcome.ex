defmodule NoshNetworkWeb.WelcomeLive.Welcome do
  use NoshNetworkWeb, :live_view

  def mount(_params, _session, socket) do
    current_name = socket.assigns.current_user.username
    address = socket.assigns.current_user.address
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(:current_name, current_name)
      |> assign(:address, address)
      |> assign(:current_user, current_user)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center overflow-hidden lg:mt-12 mt-4">
      <div class="flex flex-col items-center justify-center lg:gap-8 gap-4 font-brand max-w-[750px] p-6 text-center">
        <h1 class="lg:text-4xl text-black text-2xl">
          Welcome to
          <strong class="text-[#960e0e]">Foodies<span class="text-[#0b4927]">Network</span></strong>
        </h1>
        <h2 class="font-bold lg:text-2xl text-xl text-[#0b4927] uppercase">
          <%= @current_name %>
        </h2>

        <p class="text-base font-normal">
          Find top caterers effortlessly and ensure your event is a culinary success. Simplify your search and start planning a memorable experience today!
        </p>
        <%= if @current_user.role == "cater" do %>
          <.link href={~p"/users/onboarding"} class="btn-secondary">
            Continue
          </.link>
        <% else %>
          <.link href={~p"/users/dashboard"} class="btn-secondary">
            Continue
          </.link>
        <% end %>
      </div>
    </div>
    """
  end
end
