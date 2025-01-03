defmodule NoshNetwork.Data.Context.Bookings do
  @moduledoc """
  The Data.Context.Bookings context.
  """

  import Ecto.Query, warn: false
  alias NoshNetwork.Repo


  alias NoshNetwork.Data.Schema.Booking

  @doc """
  Returns the list of bookings.

  ## Examples

      iex> list_bookings()
      [%Booking{}, ...]

  """
  def list_bookings do
    Repo.all(Booking)
  end

  @doc """
  Gets a single booking.

  Raises `Ecto.NoResultsError` if the Booking does not exist.

  ## Examples

      iex> get_booking!(123)
      %Booking{}

      iex> get_booking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_booking!(id), do: Repo.get!(Booking, id)

  # get by user_id
  def get_bookings_by_user_id(user_id) do
    Booking
    |> where([b], b.user_id == ^user_id)
    |> Repo.all()
  end


  def get_recent_bookings_by_cater_id(cater_id, months_ago \\ 2) do
    from_date = Timex.shift(Timex.now(), months: -months_ago)
    IO.inspect(from_date, label: "From Date")
    Booking
    |> where([b], b.cater_id == ^cater_id and b.inserted_at >= ^from_date)
    |> Repo.all()
  end


  def get_bookings_by_cater_id(cater_id) do
    Booking
    |> where([b], b.cater_id == ^cater_id)
    |> Repo.all()
  end

  @doc """
  Creates a booking.

  ## Examples

      iex> create_booking(%{field: value})
      {:ok, %Booking{}}

      iex> create_booking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a booking.

  ## Examples

      iex> update_booking(booking, %{field: new_value})
      {:ok, %Booking{}}

      iex> update_booking(booking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def update_booking_status(booking, status) do
    booking
    |> Booking.status_changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  Deletes a booking.

  ## Examples

      iex> delete_booking(booking)
      {:ok, %Booking{}}

      iex> delete_booking(booking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking booking changes.

  ## Examples

      iex> change_booking(booking)
      %Ecto.Changeset{data: %Booking{}}

  """
  def change_booking(%Booking{} = booking, attrs \\ %{}) do
    Booking.changeset(booking, attrs)
  end
end
