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
    <div class="flex flex-col items-center gap-2 font-brand mx-auto justify-center max-w-[750px] p-6 lg:gap-4 text-center my-4">
      <h1 class="lg:text-4xl text-black text-2xl">Welcome to Foodies Network</h1>
      <h2 class="font-bold lg:text-2xl text-xl text-[#0b4927] capitalize"><%= @current_name %></h2>

      <p class="text-base font-normal">
        Discover top-notch caterers effortlessly, ensuring your event is a culinary triumph. Simplify your search, find the perfect match, and savor the convenience. Let us guide you to a stress-free, deliciously memorable experience. Start planning your event with confidence today!
      </p>
      <%= if @address do %>
        <.link href={~p"/users/dashboard"} class="btn-secondary">
          Continue
        </.link>
      <% else %>
        <.link href={~p"/users/onboarding"} class="btn-secondary">
          Continue
        </.link>
      <% end %>
    </div>
    """
  end
end
