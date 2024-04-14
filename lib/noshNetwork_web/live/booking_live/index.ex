defmodule NoshNetworkWeb.BookingLive.Index do
  use NoshNetworkWeb, :live_view

  alias NoshNetwork.Data.Context.Bookings
  alias NoshNetwork.Data.Schema.Booking
  alias NoshNetwork.Data.Context.Caters
  import Phoenix.HTML.Form

  def mount(%{"id" => id}, _session, socket) do
    changeset = Bookings.change_booking(%Booking{})
    user_id = socket.assigns.current_user.id
    cater_id = Caters.get_cater!(id)
    IO.inspect(cater_id.id, label: "hello ooo")

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
      |> assign(:dietary_restriction, [
        "Amala & Ewedu",
        "Pepper soup",
        "Fish"
      ])
      |> assign(:specific_dishes, [
        "Amala & Ewedu",
        "Pepper soup",
        "Fish",
        "Fried Rice",
        "Jollof Rice"
      ])
      |> assign(:valid, false)
      |> assign(:cater_id, cater_id.id)
      |> assign(:user_id, user_id)

    {:ok, socket}
  end

  def handle_event("validate", %{"booking" => params}, socket) do
    params =
      params
      |> Map.put("status", "pending")
      |> Map.put("user_id", socket.assigns.user_id)
      |> Map.put("cater_id", socket.assigns.cater_id)

    changeset =
      Booking.changeset(%Booking{}, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:valid, changeset.valid?) |> assign_form(changeset)}
  end

  def handle_event("save_booking", %{"booking" => params}, socket) do
    params =
      params
      |> Map.put("status", "pending")

    params =
      params
      |> Map.put("status", "under review")
      |> Map.put("user_id", socket.assigns.user_id)
      |> Map.put("cater_id", socket.assigns.cater_id)

    case Bookings.create_booking(params) do
      {:ok, _booking} ->
        changeset = Bookings.change_booking(%Booking{})

        socket =
          socket
          |> put_flash(:info, "Booking created successfully")
          |> push_navigate(to: ~p"/users/user_booking")
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
