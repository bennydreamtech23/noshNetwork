defmodule NoshNetworkWeb.ShowUserBookingLive.Components.QuotationTemplate do
  use NoshNetworkWeb, :live_component
  alias NoshNetwork.Repo
  alias NoshNetwork.Data.Context.Quotations

  def render(assigns) do
    ~H"""
    <div>Quotation Details</div>
    """
  end

  def update(
        %{booking_id: booking_id} = assigns,
        socket
      ) do
    quotations_details =
      Quotations.get_quotation_by_booking_id(booking_id)
      |> Repo.preload(:users)

    IO.inspect(quotations_details, label: "quotations_details ooo")

    socket =
      socket
      |> assign(assigns)
      |> assign(:quotations_details, quotations_details)

    {:ok, socket}
  end
end
