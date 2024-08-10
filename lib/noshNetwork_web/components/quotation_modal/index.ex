defmodule NoshNetworkWeb.Components.QuotationModal.Index do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Data.Context.{Items, Quotations}
  alias NoshNetwork.Data.Schema.{Item, Quotation}

  @impl true
  def update(assigns, socket) do
    # IO.inspect(assigns, label: "assigns ppppppppp")
    cater_id = assigns.cater_id
    booking_details = assigns.booking_details

    socket =
      socket
      |> assign(assigns)
      |> assign(:selected_item, nil)
      |> assign(:selected_currency, "NGN")
      |> assign(:quotation_note, "")
      |> assign(:quotation_items, [])
      |> assign(:selected_item, nil)
      |> assign(:item_quantity, 1)
      |> assign(:add_item, false)
      |> assign(:error_map, %{})
      |> assign(:search_results, [])
      |> assign(:quotation_subtotal, 0.0)
      |> assign(:fee, 20.0)
      |> assign(:quotation_total, 0.0)
      |> assign(:search_phrase, "")
      |> assign(:invoice_created, nil)
      |> assign(:search_item_results, [])
      |> assign(:quotation_id, nil)
      |> assign(:search_item_phrase, "")
      |> assign(:due_date, to_string(Date.utc_today()))
      |> assign(:quotation_date, to_string(Date.utc_today()))
      |> assign(:item_form, false)
      |> assign(:error_map_items, %{})
      |> assign(
        :item_details,
        %{
          "name" => "",
          "price" => "",
          "quantity" => "",
          "description" => ""
        }
      )
      |> assign(:valid, false)
      |> assign(:cater_id, cater_id)
      |> assign(:booking_details, booking_details)

    {:ok, socket}
  end

  def handle_event(
        "change_quantity",
        %{"change_quantity" => %{"item_quantity" => ""}} = _args,
        socket
      ) do
    {:noreply, socket |> assign(:item_quantity, 1) |> assign(:error_map, %{vat_error: ""})}
  end

  def handle_event(
        "change_quantity",
        %{"change_quantity" => %{"item_id" => item_id, "item_quantity" => quantity}},
        socket
      ) do
    item = Items.get_item(item_id)
    item_total = item.price * String.to_integer(quantity)

    updated_item = %Item{
      id: item_id,
      name: item.name,
      price: item.price,
      quantity: quantity,
      description: item.description,
      subtotal: item_total,
      cater_id: item.cater_id
    }

    quotation_items = find_and_replace_item(socket.assigns.quotation_items, updated_item)

    {quotation_subtotal, quotation_total} =
      calculate_quotation_total(
        quotation_items,
        socket.assigns.fee
      )

    assigns = [
      search_item_results: [],
      selected_item: item,
      quotation_items: quotation_items,
      quotation_subtotal: quotation_subtotal,
      quotation_total: quotation_total,
      item_quantity: String.to_integer(quantity),
      error_map: %{vat_error: ""}
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("change_fee", %{"change_fee" => ""}, socket) do
    # hardcode for Nigeria
    charges = 0.0

    {quotation_subtotal, quotation_total} =
      calculate_quotation_total(
        socket.assigns.quotation_items,
        charges
      )

    {:noreply,
     socket
     |> assign(:fee, charges)
     |> assign(:quotation_subtotal, quotation_subtotal)
     |> assign(:quotation_total, quotation_total)
     |> assign(:error_map, %{vat_error: ""})}
  end

  def handle_event("change_fee", %{"change_fee" => charges}, socket) do
    {charges, ""} = Float.parse(charges)

    case charges do
      charges when charges > 25.0 ->
        {quotation_subtotal, quotation_total} =
          calculate_quotation_total(
            socket.assigns.quotation_items,
            0.0
          )

        {:noreply,
         socket
         |> assign(:fee, 0.0)
         |> assign(:quotation_subtotal, quotation_subtotal)
         |> assign(:quotation_total, quotation_total)
         |> assign(:error_map, %{vat_error: "VAT percentage not more than 25"})}

      _ ->
        {quotation_subtotal, quotation_total} =
          calculate_quotation_total(
            socket.assigns.quotation_items,
            charges
          )

        {:noreply,
         socket
         |> assign(:fee, charges)
         |> assign(:quotation_subtotal, quotation_subtotal)
         |> assign(:quotation_total, quotation_total)
         |> assign(:error_map, %{vat_error: ""})}
    end
  end

  def handle_event("submit_quotation", data, socket) do
    case socket.assigns.due_date do
      "" ->
        {:noreply, socket |> assign(:error_map, %{due_date: "*Due date cannot be empty"})}

      _ ->
        case socket.assigns.quotation_items do
          [] ->
            {:noreply, socket |> assign(:error_map, %{item: "*Select atleast one Item"})}

          _ ->
            {quotation_subtotal, quotation_total} =
              calculate_invoice_total(
                socket.assigns.quotation_items,
                socket.assigns.fee
              )

            booking_details = socket.assigns.booking_details
            items = remove_item_ids_for_new_invoice(socket.assigns.quotation_items)

            quotation_params = %Quotation{
              reference_id: Quotations.get_new_quotation_number(),
              total: quotation_total,
              requested_by_id: booking_details.user_id,
              assigned_by_id: booking_details.cater_id,
              booking_id: booking_details.id,
              status: "draft",
              quotation_date: socket.assigns.quotation_date,
              due_date: socket.assigns.due_date,
              note: socket.assigns.quotation_note,
              fee: socket.assigns.fee,
              items: items
            }

            quotation =
              case socket.assigns.quotation_id do
                nil ->
                  new_quotation = Quotations.create_quotation_new(quotation_params)
                  IO.inspect(new_quotation, label: "what new invoice created")

                quotation_id ->
                  quotation = Quotations.get_quotation!(quotation_id)
                  Quotations.delete_quotation(quotation)

                  # Regenerate quotation parameters if necessary
                  quotation_params = %Quotation{
                    reference_id: Quotations.get_new_quotation_number(),
                    total: quotation_total,
                    requested_by_id: booking_details.user_id,
                    assigned_by_id: booking_details.cater_id,
                    booking_id: booking_details.id,
                    status: "draft",
                    quotation_date: socket.assigns.quotation_date,
                    due_date: socket.assigns.due_date,
                    note: socket.assigns.quotation_note,
                    fee: socket.assigns.fee,
                    items: items
                  }

                  Quotations.create_quotation_new(quotation_params)
              end

            {
              :noreply,
              socket
              |> assign(:quotation_created, quotation)
              |> assign(:quotation_subtotal, quotation_subtotal)
              |> assign(:show_quotation_modal, false)
              |> assign(:error_map, %{vat_error: ""})
              |> put_flash(:info, "Quotation created successful")
            }
        end
    end

    #  {:noreply,
    #   socket}
  end

  def handle_event("add_item_step", %{"step" => "add_item", "value" => _add}, socket) do
    {:noreply, socket |> assign(:add_item, true)}
  end

  def handle_event("add_new_item_row", %{"add_item_row" => value}, socket) do
    {:noreply, socket |> assign(:add_new_item_row, value)}
  end

  def handle_event("display_customer_form", %{"status" => value}, socket) do
    {:noreply, socket |> assign(:customer_form, value) |> assign(:error_map_customers, %{})}
  end

  def handle_event("set_due_date", %{"due_date" => ""}, socket), do: {:noreply, socket}

  def handle_event("set_due_date", %{"due_date" => value}, socket) do
    IO.inspect(value, label: "value of due date")
    {:noreply, socket |> assign(:due_date, value)}
  end

  def handle_event("set_quotation_date", %{"quotation_date" => ""}, socket),
    do: {:noreply, socket}

  def handle_event("set_quotation_date", %{"quotation_date" => value}, socket) do
    IO.inspect(value, label: "value of quotation_date")
    {:noreply, socket |> assign(:quotation_date, value)}
  end

  @impl true
  def handle_event("validate", _target, socket) do
    {:noreply, socket}
  end

  def handle_event("search_item", %{"search_item_phrase" => search_item_phrase}, socket) do
    assigns = [
      search_item_results: search_item(search_item_phrase, socket.assigns.cater_id),
      search_item_phrase: search_item_phrase
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick_item", %{"name" => selected_item}, socket) do
    [item | _rest] = Items.get_item_by_name(selected_item, socket.assigns.cater_id)
    items = socket.assigns.quotation_items ++ [item]

    {quotation_subtotal, quotation_total} =
      calculate_quotation_total(
        items,
        socket.assigns.fee
      )

    assigns = [
      search_item_results: [],
      search_item_phrase: selected_item,
      selected_item: item,
      quotation_items: items,
      quotation_subtotal: quotation_subtotal,
      quotation_total: quotation_total,
      error_map: %{vat_error: ""}
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("add_description", %{"note" => note}, socket) do
    {:noreply, socket |> assign(:quotation_note, note) |> assign(:error_map, %{vat_error: ""})}
  end

  def handle_event("display_item_form", %{"status" => value}, socket) do
    IO.inspect(value, label: "display_item_form")
    {:noreply, socket |> assign(:item_form, value) |> assign(:error_map_items, %{})}
  end

  def handle_event("save_item_form", %{"status" => "close"} = _data, socket) do
    {:noreply,
     socket
     |> assign(:item_form, false)
     |> assign(:error_map_items, %{})}
  end

  def handle_event("validate_item_form", data, socket) do
    case validate_input_data(data, ["item_name", "item_price"]) do
      :ok ->
        {:noreply, socket |> assign(:valid, true) |> assign(:error_map_items, %{})}

      {:error, error_map} ->
        item_details = %{
          "name" => Map.get(data, "item_name", ""),
          "price" => Map.get(data, "item_price", ""),
          "quantity" => Map.get(data, "item_quantity", "1"),
          "currency" => Map.get(data, "item_currency", ""),
          "description" => Map.get(data, "item_description", "")
        }

        {:noreply,
         socket |> assign(:error_map_items, error_map) |> assign(:item_details, item_details)}
    end
  end

  def handle_event("save_item_form", %{"status" => _value} = data, socket) do
    case validate_input_data(data, ["item_name", "item_price"]) do
      {:error, error_map} ->
        item_details = %{
          "name" => Map.get(data, "item_name", ""),
          "price" => Map.get(data, "item_price", ""),
          "quantity" => Map.get(data, "item_quantity", "1"),
          "description" => Map.get(data, "item_description", "")
        }

        IO.inspect(error_map, label: "error_map")

        {:noreply,
         socket |> assign(:error_map_items, error_map) |> assign(:item_details, item_details)}

      :ok ->
        {price, _} = Float.parse(data["item_price"])

        item = %{
          name: data["item_name"],
          price: price,
          quantity: "1",
          subtotal: price * String.to_integer("1"),
          description: data["item_description"],
          cater_id: socket.assigns.cater_id
        }

        {:ok, new_item} = Items.create_item(item)
        items = socket.assigns.quotation_items ++ [new_item]

        {quotation_subtotal, quotation_total} =
          calculate_quotation_total(
            items,
            socket.assigns.fee
          )

        {:noreply,
         socket
         |> assign(:item_form, false)
         |> assign(:quotation_items, items)
         |> assign(:quotation_subtotal, quotation_subtotal)
         |> assign(:quotation_total, quotation_total)}
    end
  end

  def handle_event("delete_item", %{"item-id" => item_id}, socket) do
    item = Enum.find(socket.assigns.quotation_items, fn x -> x.id == item_id end)
    items = socket.assigns.quotation_items -- [item]

    {quotation_subtotal, quotation_total} =
      calculate_quotation_total(
        items,
        socket.assigns.fee
      )

    {:noreply,
     socket
     |> assign(:quotation_items, items)
     |> assign(:quotation_subtotal, quotation_subtotal)
     |> assign(:quotation_total, quotation_total)
     |> assign(:error_map, %{vat_error: ""})}
  end

  def handle_event(_event, _data, socket) do
    {:noreply, socket}
  end

  ## Internal Functions

  defp search_item("", _), do: []

  defp search_item(search_item_phrase, user_id) do
    item_names(user_id)
    |> Enum.filter(&matches?(&1, search_item_phrase))
  end

  defp matches?(first, second) do
    String.starts_with?(
      String.downcase(first),
      String.downcase(second)
    )
  end

  defp item_names(cater_id) do
    list_of_item_name_maps = Items.get_all_items_by_name(cater_id)

    :lists.usort(
      List.foldl(list_of_item_name_maps, [], fn x, acc -> acc ++ [Map.get(x, :name)] end)
    )
  end

  defp calculate_quotation_total(items, fee) do
    subtotal = Enum.reduce(items, 0.0, fn item, acc -> item.subtotal + acc end)
    # fee = subtotal + fee
    total = subtotal + fee
    {subtotal, total}
  end

  defp find_and_replace_item(quotation_items, item) do
    item_found = Enum.find(quotation_items, fn x -> x.id == item.id end)
    updated_list = quotation_items -- [item_found]
    updated_list ++ [item]
  end

  defp remove_item_ids_for_new_invoice(quotation_items) do
    Enum.reduce(quotation_items, [], fn x, acc ->
      acc ++
        [
          %Item{
            id: nil,
            name: x.name,
            price: x.price,
            quantity: x.quantity,
            subtotal: x.subtotal,
            description: x.description,
            cater_id: x.cater_id,
            quotation_id: x.quotation_id
          }
        ]
    end)
  end

  defp validate_input_data(data, list_to_validate) do
    error_map =
      Enum.reduce(list_to_validate, %{}, fn x, acc ->
        case Map.get(data, x) do
          "" -> Map.put(acc, x, "Cannot be empty")
          _ -> acc
        end
      end)

    case Map.to_list(error_map) do
      [] -> :ok
      _ -> {:error, error_map}
    end
  end

  defp find_changed_fields(changed_map, current_map) do
    case Map.equal?(changed_map, current_map) do
      true ->
        %{ignore: "ignore_value"}

      false ->
        changed_list = Map.to_list(changed_map)
        current_list = Map.to_list(current_map)

        changed_key_value_list =
          changed_list -- Enum.filter(changed_list, fn x -> Enum.member?(current_list, x) end)

        :proplists.to_map(changed_key_value_list)
    end
  end

  defp check_param(nil) do
    ""
  end

  defp check_param(value) do
    value
  end

  defp calculate_invoice_total(items, fee) do
    subtotal = Enum.reduce(items, 0.0, fn item, acc -> item.subtotal + acc end)
    vat = fee
    total = subtotal + vat
    {subtotal, total}
  end

  defp button_valid(true), do: "btn-primary"
  defp button_valid(false), do: "btn-disabled"
end
