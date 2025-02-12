defmodule NoshNetworkWeb.CardComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="bg-white shadow-md rounded-lg overflow-hidden">
      <!-- Card Image -->
      <img src={@image_url} alt={@alt_text} class="w-full h-44 object-cover" />
      <!-- Card Content -->
      <div class="p-4">
        <h2
          class="cursor-pointer text-lg font-bold text-gray-800 mb-2"
          phx-value-id={@id}
          phx-click="get_caterer_details"
        >
          <%= @title %>
        </h2>
        <p class="text-gray-600">
          <%= "#{@address}, #{@city}, #{@country}" %>
        </p>

        <button
          id={"caterer-#{@cater_id}"}
          phx-click="booking_action"
          class="btn-primary my-4 w-full"
          phx-value-cater_id={@cater_id}
        >
          Book Now
        </button>
      </div>
    </div>
    """
  end
end
