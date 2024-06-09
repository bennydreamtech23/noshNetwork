defmodule NoshNetworkWeb.Components.Modal.Index do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Data.Context.{Items, Quotations}
  alias NoshNetwork.Data.Schema.{Item, Quotation}

  def update(assigns, socket) do
    show_quotation_modal = assigns.show_quotation_modal
    changeset = Items.change_item(%Item{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:show_quotation_modal, show_quotation_modal)
      |> assign(:show_item, false)
      |> assign(:items, [])
      |> assign(:note, "")
      |> assign(:valid, false)
      |> assign_form(changeset)

    {:ok, socket}
  end

  # def handle_event("back", _params, socket) do
  #   {:noreply, assign(socket, :show_quotation_modal, false)}
  # end

  def handle_event("back", _params, socket) do
    {:noreply,
     socket
     |> push_navigate(to: ~p"/users/dashboard")}
  end

  def handle_event("add-item", _params, socket) do
    {:noreply, assign(socket, :show_item, true)}
  end

  # save and validate item

  def handle_event("validate", %{"item" => params}, socket) do
    IO.inspect(params, label: "items what we have here")

    changeset =
      Item.changeset(%Item{}, params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:valid, changeset.valid?) |> assign_form(changeset)}
  end

  def handle_event("save", %{"item" => params}, socket) do
    case Items.create_item(params) do
      {:ok, _item} ->
        changeset = Items.change_item(%Item{})
        # Refresh the list of items
        items = Items.list_items()

        socket =
          socket
          |> put_flash(:info, "Item added successfully")
          |> assign(:valid, false)
          # Update the items list
          |> assign(:items, items)
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
