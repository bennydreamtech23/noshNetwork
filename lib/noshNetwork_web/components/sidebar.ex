defmodule NoshNetworkWeb.Sidebar do
  use NoshNetworkWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-gray-100 sidebar fixed top-16 left-0 z-10 w-60 p-4 border rounded-md shadow-md text-black mt-4 overflow-y-auto h-[calc(100vh-5rem)]">
      <!-- Navigation Links -->
      <nav class="space-y-8 mt-4">
        <%= for link <- @links do %>
          <a
            href={link.path}
            class={[
              "cursor-pointer block py-2 px-4 rounded text-center transition-transform transform hover:scale-105 shadow-md",
              @current_path == link.path && "bg-green-500 text-white",
              @current_path != link.path && "bg-white text-black hover:bg-green-500 hover:text-white"
            ]}
          >
            <%= link.label %>
          </a>
        <% end %>
      </nav>
      <style>
        @media (max-width: 1019px) {
        .sidebar {
        display: none;
        }
        }

        @media (min-width: 1020px) {
        .sidebar {
        display: block;
        }
        }
      </style>
    </div>
    """
  end
end
