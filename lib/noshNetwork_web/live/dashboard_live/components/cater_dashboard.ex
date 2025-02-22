defmodule NoshNetworkWeb.DashboardLive.Components.CaterDashboard do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Data.Context.{Bookings, Caters}
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <section class="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 gap-6 p-4">
        <div class="bg-white shadow rounded-lg p-4 text-center">
          <p class="text-gray-500">Total Booked</p>
          <h2 class="text-2xl font-bold">0.00</h2>
        </div>
        <div class="bg-white shadow rounded-lg p-4 text-center">
          <p class="text-gray-500">Total Clients</p>
          <h2 class="text-2xl font-bold">0.00</h2>
        </div>

        <div class="bg-white shadow rounded-lg p-4 text-center">
          <p class="text-gray-500">Total Revnue</p>
          <h2 class="text-2xl font-bold">$0.00</h2>
        </div>
      </section>

      <section class="flex md:flex-row flex-col items-start gap-0 md:gap-4 justify-between">
        <div class="md:w-4/6 w-full flex flex-col gap-4">
          <div class='w-full h-full'>
            <h1 class="font-bold text-lg">Total Revenue</h1>
            <canvas id="my-chart" phx-hook="Chart" data-incomes={Jason.encode!(@incomes)}></canvas>
          </div>
          <div style='wdith: 400px; height: 400px'>
            <!-- Adjust width & height as needed -->
            <h1 class="font-bold text-lg">Performance Level</h1>
            <canvas
              id="droghnut-chart"
              phx-hook="DoughnutChart"
              data-incomes={Jason.encode!(@incomes)}
              class="w-full h-full"

            >
            </canvas>
          </div>
        </div>

        <div>
          <h1 class="font-bold text-lg mb-4">Recent Booking</h1>
          <div class="flex items-center bg-[#D9D9D9] px-4 py-2 justify-between gap-4 border rounded-md my-4">
            <div>
              <h2 class="font-bold text-base">Anastasia John</h2>
              <p class="text-xs">Naming ceremony</p>
            </div>
            <h1 class="text-sm">15th Feb 2025</h1>
          </div>

          <div class="flex items-center bg-[#D9D9D9] px-4 py-2 justify-between gap-4 border rounded-md">
            <div>
              <h2 class="font-bold text-base">Anastasia John</h2>
              <p class="text-xs">Naming ceremony</p>
            </div>
            <h1 class="text-sm">15th Feb 2025</h1>
          </div>
        </div>
      </section>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    current_user = assigns.current_user

    cater = Caters.get_cater_by_user_id(current_user.id)

    user_booking = if cater, do: Bookings.get_recent_bookings_by_cater_id(cater.id), else: []
    IO.inspect(user_booking, label: "booking")

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:incomes, [10000, 20000, 30000, 40000, 50000, 100_000])}
  end
end
