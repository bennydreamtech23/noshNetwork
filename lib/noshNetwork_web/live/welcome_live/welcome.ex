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
    <div class="h-screen flex items-center justify-center font-brand">
      <div
        class="max-w-sm flex flex-col gap-4 items-center justify-center p-6 border rounded-md shadow-lg"
        style="background-color: #FAFAFA;"
      >
        <img src="/icons/check_icon.png" alt="img" class="h-[100px] w-[100px]" />

        <h1 class="font-bold text-xl text-center">Woo-hoo, you're all set up!</h1>

        <p class="font-normal text-center">
          We're excited to have you onboard, <strong><%= @current_name %></strong>
        </p>

        <div class="my-4 w-full">
          <%= if @current_user.role == "cater" do %>
            <.link
              href={~p"/users/onboarding"}
              class="w-full px-4 py-2 bg-black text-white border border-black rounded hover:bg-transparent hover:text-black text-center block"
            >
              Continue
            </.link>
          <% else %>
            <.link
              href={~p"/users/dashboard"}
              class="w-full px-4 py-2 bg-black text-white border border-black rounded hover:bg-transparent hover:text-black text-center block"
            >
              Continue
            </.link>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
