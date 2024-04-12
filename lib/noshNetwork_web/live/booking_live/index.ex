defmodule NoshNetworkWeb.BookingLive.Index do
  use NoshNetworkWeb, :live_view

  alias NoshNetwork.Data.Context.Bookings
  alias NoshNetwork.Data.Schema.Booking
  import Phoenix.HTML.Form

  def mount(_params, _session, socket) do
    changeset = Bookings.change_booking(%Booking{})
    user_id = socket.assigns.current_user.id
    IO.inspect(user_id, label: "hello")

    socket =
      socket
      |> assign_form(changeset)
      |> assign(:event_type, [
        "Naming ceremony",
        "Birthday ceremony",
        "House warming",
        "Retirement",
        "Burial ceremony",
        "Remembrance"
      ])
      |> assign(:cusine_preference, [
        "Nigerian cusine",
        "Chinese cusine",
        "African Cusine",
        "American cusine",
        "Indian cusine"
      ])
      |> assign(:service_type, [
        "Buffet",
        "Plated Dinner",
        "Cocktail Reception",
        "Amala Spot",
        "Buka Formation",
        "Food Station",
        "Food truck",
        "Boxed Meals"
      ])
      |> assign(:valid, false)

    {:ok, socket}
  end

  def handle_event("validate", %{"booking" => params}, socket) do
    params =
      params
      |> Map.put("status", "pending")

    changeset =
      Booking.changeset(%Booking{}, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:valid, changeset.valid?) |> assign_form(changeset)}
  end

  def handle_event("save_booking", %{"booking" => params}, socket) do
    params =
      params
      |> Map.put("status", "pending")

    case Bookings.create_booking(params) do
      {:ok, _booking} ->
        changeset = changeset = Bookings.change_booking(%Booking{})

        socket =
          socket
          |> put_flash(:info, "Booking created successfully")
          |> push_navigate(to: ~p"/users/dashboard")
          |> assign(:valid, false)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp button_valid(true), do: "bg-emOrange-dark"
  defp button_valid(false), do: "bg-zinc-600"
end
