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
      |> assign(:quotation_description, "")
      |> assign(:quotation_items, [])
      |> assign(:selected_item, nil)
      |> assign(:item_quantity, 1)
      |> assign(:add_item, false)
      |> assign(:error_map, %{})
      |> assign(:search_results, [])
      |> assign(:quotation_subtotal, 0.0)
      |> assign(:fee, 0.0)
      |> assign(:quotation_total, 0.0)
      |> assign(:search_phrase, "")
      |> assign(:search_item_results, [])
      |> assign(:search_item_phrase, "")
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
    fee = 0.0

    {quotation_subtotal, quotation_total} =
      calculate_quotation_total(
        socket.assigns.quotation_items,
        fee
      )

    {:noreply,
     socket
     |> assign(:fee, fee)
     |> assign(:quotation_subtotal, quotation_subtotal)
     |> assign(:quotation_total, quotation_total)
     |> assign(:error_map, %{vat_error: ""})}
  end

  def handle_event("change_fee", %{"change_fee" => fee}, socket) do
    {fee, ""} = Float.parse(fee)

    case fee do
      fee when fee > 25.0 ->
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
            socket.assigns.invoice_items,
            fee
          )

        {:noreply,
         socket
         |> assign(:fee, fee)
         |> assign(:quotation_subtotal, quotation_subtotal)
         |> assign(:quotation_total, quotation_total)
         |> assign(:error_map, %{vat_error: ""})}
    end
  end

  def handle_event("submit_quotation", data, socket) do
    {quotation_subtotal, quotation_total} =
      calculate_invoice_total(
        socket.assigns.quotation_items,
        socket.assigns.fee
      )

    invoice_params = %Quotation{
      # invoice_number: Invoices.get_new_invoice_number(socket.assigns.user_id),

      total: quotation_total

      # items: remove_item_ids_for_new_invoice(socket.assigns.invoice_items),
    }

    # Invoices.create_invoice_new(invoice_params)

    {
      :noreply,
      socket
      #  |> assign(:invoice_created, invoice)
      #  |> assign(:invoice_subtotal, invoice_subtotal)
      #  |> assign(:error_map, %{vat_error: ""})
    }
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
    {:noreply, socket |> assign(:due_date, value)}
  end

  def handle_event("set_invoice_date", %{"invoice_date" => ""}, socket), do: {:noreply, socket}

  def handle_event("set_invoice_date", %{"invoice_date" => value}, socket) do
    {:noreply, socket |> assign(:invoice_date, value)}
  end

  def handle_event("toggle_save_template_modal", _data, socket) do
    {:noreply, socket |> assign(:save_as_template, !socket.assigns.save_as_template)}
  end

  # def handle_event("send_invoice", %{"save_template" => value}, socket) do
  #   invoice = socket.assigns.invoice_created

  #   case invoice.is_template do
  #     false ->
  #       Invoices.update_invoice(invoice, %{status: "unpaid", is_template: value})

  #     true ->
  #       Invoices.update_invoice(invoice, %{status: "unpaid"})
  #   end

  #   send_invoice(socket, socket.assigns.action, invoice)
  # end

  def handle_event("cancel_invoice", _data, socket) do
    invoice = socket.assigns.invoice_created

    if invoice.status == "draft" do
      Invoices.delete_invoice(invoice)
    end

    {:noreply, socket |> redirect(to: "#{socket.assigns.redirect_url}")}
  end

  # def handle_event("save-signature", _data, socket) do
  #  uploaded_files = upload_file(socket)
  #  {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  # end

  @impl true
  def handle_event("validate", _target, socket) do
    {:noreply, socket}
  end

  def handle_event("search", %{"search_phrase" => search_phrase}, socket) do
    assigns = [
      search_results: search(search_phrase, socket.assigns.user_id),
      search_phrase: search_phrase
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick", %{"name" => selected_customer}, socket) do
    [customer | _rest] = Customers.get_customer_by_name(selected_customer, socket.assigns.user_id)

    assigns = [
      search_results: [],
      search_phrase: selected_customer,
      selected_customer: customer,
      error_map: %{vat_error: ""}
    ]

    {:noreply, assign(socket, assigns)}
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

  def handle_event("add_description", %{"description" => description}, socket) do
    {:noreply,
     socket |> assign(:invoice_description, description) |> assign(:error_map, %{vat_error: ""})}
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
        IO.inspect(price, label: "price is here")

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

  # def handle_event("send_invoice_sms", _, socket) do
  #   send_sms =
  #     case socket.assigns.send_invoice_sms do
  #       true -> false
  #       false -> true
  #     end

  #   {:noreply, socket |> assign(:send_invoice_sms, send_sms)}
  # end

  def handle_event(_event, _data, socket) do
    {:noreply, socket}
  end

  ## Internal Functions

  defp search_item("", _), do: []

  defp search_item(search_item_phrase, user_id) do
    item_names(user_id)
    |> Enum.filter(&matches?(&1, search_item_phrase))
  end

  defp search("", _), do: []

  defp search(search_phrase, user_id) do
    customer_names(user_id)
    |> Enum.filter(&matches?(&1, search_phrase))
  end

  defp matches?(first, second) do
    String.starts_with?(
      String.downcase(first),
      String.downcase(second)
    )
  end

  defp customer_names(user_id) do
    list_of_customer_name_maps = Customers.get_all_customers_by_name(user_id)

    :lists.usort(
      List.foldl(list_of_customer_name_maps, [], fn x, acc ->
        acc ++ [Map.get(x, :business_name)]
      end)
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
    fee = subtotal * fee / 100
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
            cater_id: x.cater_id
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

  defp maybe_update_invoice_with_currency_and_wallet(nil, _, _) do
    :do_nothing
  end

  defp maybe_update_invoice_with_currency_and_wallet(invoice, currency, wallet_number) do
    Invoices.update_invoice(invoice, %{currency: currency, receiver_wallet: wallet_number})
  end

    defp calculate_invoice_total(items, fee) do
    subtotal = Enum.reduce(items, 0.0, fn item, acc -> item.subtotal + acc end)
    vat = subtotal * fee / 100
    total = subtotal + vat
    {subtotal, total}
  end

  defp button_valid(true), do: "btn-primary"
  defp button_valid(false), do: "btn-disabled"
end
