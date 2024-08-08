defmodule NoshNetworkWeb.DashboardLive.Components.BookingDetails do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Repo
  alias NoshNetwork.Data.Context.{Bookings, Users}

  def render(assigns) do
    ~H"""
    <div id="bookings_details" class="w-full fixed right-0 shadow-lg top-4 slider-overlay">
      <div class="slider-container">
        <div class="slider-content">
          <div class="flex flex-col justify-center m-auto p-5 space-y-4 rounded-md">
            <div class=" p-3 rounded-md mb-4 flex flex-col">
              <div class="flex justify-between items-center">
                <p>Booking Details</p>
                <div class="my-4 flex justify-end ">
                  <a
                    phx-click={JS.navigate(~p"/users/dashboard")}
                    href="#"
                    phx-target={@myself}
                    class="font-bold text-2xl text-figcolor"
                  >
                    <i class="fa-regular fa-xmark"></i>
                  </a>
                </div>
              </div>
              <ul class="space-y-5">
                <li class="flex flex-col justify-between  pb-2">
                  <p class="font-bold pb-2">Booker Name</p>
                  <p class="border-2 p-2 rounded-sm">
                    <%= @booking_details.users.name %>
                  </p>
                </li>

                <li class="flex flex-col justify-between  pb-2">
                  <p class="font-bold pb-2">Booker Email</p>
                  <p class="border-2 p-2 rounded-sm">
                    <%= @booking_details.users.email %>
                  </p>
                </li>

                <li class="flex flex-col justify-between  pb-2">
                  <p class="font-bold pb-2">Booker Phone Number</p>
                  <p class="border-2 p-2 rounded-sm">
                    <%= @booking_details.users.phone_number %>
                  </p>
                </li>

                <li class="flex flex-col justify-between  pb-2">
                  <p class="font-bold pb-2">Event Date</p>
                  <p class="border-2 p-2 rounded-sm">
                    <%= @booking_details.event_date %>
                  </p>
                </li>
                <li class="flex flex-col justify-between pb-2">
                  <p class="font-bold pb-2">Cuisine Preferences</p>
                  <ul class="border-2 p-2 rounded-sm">
                    <%= for preference <- @booking_details.cusine_preference do %>
                      <li class="p-1"><%= preference %></li>
                    <% end %>
                  </ul>
                </li>

                <li class="flex flex-col justify-between pb-2">
                  <p class="font-bold pb-2">Service Type</p>
                  <ul class="border-2 p-2 rounded-sm">
                    <%= for services <- @booking_details.service_type do %>
                      <li class="p-1"><%= services %></li>
                    <% end %>
                  </ul>
                </li>

                <li class="flex flex-col justify-between pb-2">
                  <p class="font-bold pb-2">Dietary Restriction</p>
                  <ul class="border-2 p-2 rounded-sm">
                    <%= for dietary_restriction <- @booking_details.dietary_restriction do %>
                      <li class="p-1"><%= dietary_restriction %></li>
                    <% end %>
                  </ul>
                </li>

                <li class="flex flex-col justify-between pb-2">
                  <p class="font-bold pb-2">Specific Dishes</p>
                  <ul class="border-2 p-2 rounded-sm">
                    <%= for specific_dishes <- @booking_details.specific_dishes do %>
                      <li class="p-1"><%= specific_dishes %></li>
                    <% end %>
                  </ul>
                </li>

                <li class="flex flex-col justify-between pb-2">
                  <p class="font-bold pb-2">Additional services</p>
                  <%= if @booking_details && @booking_details.additional_service do %>
                    <p class="border-2 p-2 rounded-sm">
                      <%= @booking_details.additional_service %>
                    </p>
                  <% else %>
                    <p class="border-2 p-2 rounded-sm">None</p>
                  <% end %>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    booking_details =
      Bookings.get_booking!(assigns.booking_id)
      |> Repo.preload(:users)

    IO.inspect(booking_details, label: "booking_details")

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:booking_details, booking_details)}
  end
end
