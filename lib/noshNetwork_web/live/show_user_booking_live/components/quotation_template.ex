defmodule NoshNetworkWeb.ShowUserBookingLive.Components.QuotationTemplate do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Repo
  alias NoshNetwork.Data.Context.Quotations

  def render(assigns) do
    ~H"""
    <div style="gap:30px" class="flex justify-between gap-6">
      <div class="flex flex-col">
        <div class="flex flex-col py-2 space-y-3">
          <p class="text-sm text-sidebarcolor font-medium">BILL FROM</p>
          <p style="color:#323A3D" class="text-sm text-sidebarcolor font-medium whitespace-nowrap">
            <%= @quotations_details.assigned_by.user.business_name %>
          </p>
          <p style="color:#323A3D" class="text-sm text-sidebarcolor font-medium whitespace-nowrap">
            <%= @quotations_details.assigned_by.user.email %>
          </p>
          <%= if  @quotations_details.assigned_by.user.phone_number do %>
            <p style="color:#323A3D" class="text-sm text-sidebarcolor font-medium whitespace-nowrap">
              <%= @quotations_details.assigned_by.user.phone_number %>
            </p>
          <% end %>

          <p style="color:#323A3D" class="text-sm text-sidebarcolor font-medium whitespace-nowrap">
            <%= @quotations_details.assigned_by.user.address %>
          </p>
        </div>
        <div class="flex flex-col py-2 space-y-3 mt-5">
          <div class="flex items-center ">
            <p style="color:#323A3D;width: 130px;" class="text-sm  font-medium">Bill To:</p>
            <p style="color:#323A3D" class="text-sm  font-medium whitespace-nowrap">
              <%= @quotations_details.requested_by.name %>
            </p>
          </div>

          <div class="flex items-center">
            <p style="color:#323A3D;width: 130px;" class="text-sm">Email:</p>
            <p style="color:#323A3D" class="text-sm  font-medium whitespace-nowrap">
              <%= @quotations_details.requested_by.email %>
            </p>
          </div>
          <div style="color:#323A3D" class="flex items-center">
            <p style="color:#323A3D;width: 130px;" class="text-sm">
              Address:
            </p>
            <p style="color:#323A3D" class="text-sm  font-medium whitespace-nowrap">
              <%= @quotations_details.requested_by.address %>
            </p>
          </div>
        </div>

        <ul class=" py-6 space-y-3">
          <li class="flex gap-3 justify-end">
            <p class="text-sm text-sidebarcolor text-[#323A3D] font-medium">Quotation #</p>
            <p class="text-sm text-[#323A3D] text-sidebarcolor font-medium whitespace-nowrap">
              <%= @quotations_details.reference_id %>
            </p>
          </li>
          <li class="flex gap-3 justify-end ">
            <p class="text-sm text-sidebarcolor font-medium text-[#323A3D]">Date</p>
            <p class="text-sm text-sidebarcolor font-medium whitespace-nowrap text-[#323A3D]">
              <%= @quotations_details.quotation_date %>
            </p>
          </li>
          <li class="flex gap-3 justify-end ">
            <p class="text-sm text-sidebarcolor font-medium text-end whitespace-nowrap text-[#323A3D]">
              Date Due
            </p>
            <p class="text-sm text-sidebarcolor font-medium text-end whitespace-nowrap text-[#323A3D]">
              <%= @quotations_details.due_date %>
            </p>
          </li>
        </ul>

        <div class="overflow-x-auto p-3   ">
          <table class="min-w-full divide-y divide-gray-200">
            <thead>
              <tr class="bg-[#252539] text-white ">
                <!--<th class="py-3 px-4 text-left font-medium" scope="col">
                              #
                            </th>-->
                <th class="py-3 px-4 text-left font-medium" scope="col">
                  Item & Description
                </th>
                <th class="py-3 px-4 text-left font-medium" scope="col">
                  Qty
                </th>
                <th class="py-3 px-4 text-left font-medium" scope="col">
                  Rate
                </th>
                <th class="py-3 px-4 text-left font-medium" scope="col">
                  Amount
                </th>
              </tr>
            </thead>
            <tbody class=" divide-y divide-gray-200">
              <%= for item <- @quotations_details.items do %>
                <tr class="border-b">
                  <!--<td class="py-2 px-4  font-light text-sm">
                              1
                            </td>-->
                  <td class=" w-[400px] py-2 px-4  font-bold text-md">
                    <%= item.name %>
                  </td>
                  <td class="py-2 px-4  font-bold text-md whitespace-nowrap">
                    <%= item.quantity %>
                  </td>
                  <td class="w-[270px] py-2 px-4 font-bold text-md">
                    UNIT PRICE
                  </td>
                  <td class="py-2 px-4 font-bold text-md">
                    <%= Number.Delimit.number_to_delimited(
                      :erlang.float_to_binary(item.price * String.to_integer(item.quantity), [
                        :compact,
                        {:decimals, 10}
                      ])
                    ) %>
                  </td>
                </tr>
              <% end %>
              <!-- Repeat the above row for other items -->
            </tbody>
            <tfoot>
              <tr>
                <td colspan="2"></td>
                <td class="py-2 px-4" class="text-right font-light text-sm">
                  Sub Total
                </td>
                <td class="py-2 px-4 font-light text-sm whitespace-nowrap">
                  <%= Number.Delimit.number_to_delimited(
                    :erlang.float_to_binary(@quotation_subtotal, [
                      :compact,
                      {:decimals, 10}
                    ])
                  ) %>
                </td>
              </tr>
              <tr>
                <td colspan="2"></td>
                <td class="py-2 px-4" class="text-right font-light text-sm">
                  Fee
                </td>
                <td class="py-2 px-4 font-light text-sm whitespace-nowrap">
                  <%= Number.Delimit.number_to_delimited(
                    :erlang.float_to_binary(@quotations_details.fee, [
                      :compact,
                      {:decimals, 10}
                    ])
                  ) %>
                </td>
              </tr>
              <tr>
                <td colspan="2"></td>
                <td class="py-2 px-4" class="text-right font-light text-sm">
                  Total
                </td>
                <td class="py-2 px-4 font-light text-sm whitespace-nowrap">
                  <%= Number.Delimit.number_to_delimited(
                    :erlang.float_to_binary(@quotations_details.total, [
                      :compact,
                      {:decimals, 10}
                    ])
                  ) %>
                </td>
              </tr>
              <tr>
                <td colspan="2"></td>
                <%!-- <td class="py-2 px-4 font-light text-sm whitespace-nowrap">
                Balance Due
              </td>
              <td class="py-2 px-4 font-light text-sm bg-neutral-100 whitespace-nowrap">
                <%= Number.Delimit.number_to_delimited(
                  :erlang.float_to_binary(@quotations_details.amount_paid, [
                    :compact,
                    {:decimals, 10}
                  ])
                ) %>
              </td> --%>
              </tr>
            </tfoot>
          </table>
          <%= if @quotations_details.note do %>
            <p class="text-xs"><%= @quotations_details.note %></p>
          <% end %>

          <div>
            <button>Pay</button>
            <button>Request Negotation</button>
          </div>

          <div
            style="color:#878C94"
            class="mt-[200px] h-[8rem] flex justify-center items-center flex-col"
          >
            <p class="text-center">
              This Quotation  was designed with the help of FoodieNetwork
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def update(
        %{booking_id: booking_id} = assigns,
        socket
      ) do
    quotations_details =
      Quotations.get_quotation_by_booking_id(booking_id)
      |> Repo.preload(assigned_by: :user)
      |> Repo.preload(:requested_by)

    IO.inspect(quotations_details, label: "quotations_details ooo")
    quotation_subtotal = quotations_details.total - quotations_details.fee

    socket =
      socket
      |> assign(assigns)
      |> assign(:quotations_details, quotations_details)
      |> assign(:quotation_subtotal, quotation_subtotal)

    {:ok, socket}
  end
end
