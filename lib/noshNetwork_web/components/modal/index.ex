defmodule NoshNetworkWeb.Components.Modal.Index do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Data.Context.Items
  alias NoshNetwork.Data.Schema.Item

  def update(assigns, socket) do
    show_quotation_modal = assigns.show_quotation_modal
    changeset = Items.change_item(%Item{})
    items = Items.list_items()

    socket =
      socket
      |> assign(assigns)
      |> assign(:show_quotation_modal, show_quotation_modal)
      |> assign(:show_item, false)
      |> assign(:items, items)
      |> assign(:note, "")
      |> assign(:valid, false)
      |> assign(:subtotal, 0)
      |> assign(:fee, 0)
      |> assign(:total, 0)
      |> assign_form(changeset)

    {:ok, socket}
  end

  def handle_event("back", _params, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/users/dashboard")}
  end

  def handle_event("add-item", _params, socket) do
    {:noreply, assign(socket, :show_item, true)}
  end

  def handle_event("validate", %{"item" => params}, socket) do
    changeset =
      Item.changeset(%Item{}, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:valid, changeset.valid?) |> assign_form(changeset)}
  end

  def handle_event("save", %{"item" => params}, socket) do
    case Items.create_item(params) do
      {:ok, _item} ->
        changeset = Items.change_item(%Item{})
        items = Items.list_items()
        subtotal = Enum.reduce(items, 0, fn item, acc -> acc + item.price * item.quantity end)
        # Replace with actual fee calculation if needed
        fee = 0
        total = subtotal + fee

        socket =
          socket
          |> put_flash(:info, "Item added successfully")
          |> assign(:valid, false)
          |> assign(:items, items)
          |> assign(:subtotal, subtotal)
          |> assign(:fee, fee)
          |> assign(:total, total)
          |> assign_form(changeset)

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
