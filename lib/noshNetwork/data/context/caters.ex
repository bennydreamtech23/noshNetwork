defmodule NoshNetwork.Data.Context.Caters do
  @moduledoc """
  The Data.Context.Caters context.
  """

  import Ecto.Query, warn: false
  alias NoshNetwork.Repo

  alias NoshNetwork.Data.Schema.Cater
  alias NoshNetwork.Data.Schema.User

  @doc """
  Returns the list of caters.

  ## Examples

      iex> list_caters()
      [%Cater{}, ...]

  """
  def list_caters do
    Repo.all(Cater)
  end

  @doc """
  Gets a single cater.

  Raises `Ecto.NoResultsError` if the Cater does not exist.

  ## Examples

      iex> get_cater!(123)
      %Cater{}

      iex> get_cater!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cater!(id), do: Repo.get!(Cater, id)

  def get_cater_by_user_id(user_id) do
    Repo.get_by(Cater, user_id: user_id)
  end

  @doc """
  Creates a cater.

  ## Examples

      iex> create_cater(%{field: value})
      {:ok, %Cater{}}

      iex> create_cater(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_cater(attrs \\ %{}) do
    %Cater{}
    |> Cater.changeset(attrs)
    |> Repo.insert()
  end

  # def create_cater(user, attrs \\ %{}) do
  #   user
  #   |> Ecto.build_assoc(:caters)
  #   |> Cater.changeset(attrs)
  #   |> Repo.insert()
  # end

  @doc """
  Updates a cater.

  ## Examples

      iex> update_cater(cater, %{field: new_value})
      {:ok, %Cater{}}

      iex> update_cater(cater, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_cater(%Cater{} = cater, attrs) do
    cater
    |> Cater.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cater.

  ## Examples

      iex> delete_cater(cater)
      {:ok, %Cater{}}

      iex> delete_cater(cater)
      {:error, %Ecto.Changeset{}}

  """

  def delete_cater(%Cater{} = cater) do
    Repo.delete(cater)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cater changes.

  ## Examples

      iex> change_cater(cater)
      %Ecto.Changeset{data: %Cater{}}

  """
  def change_cater(%Cater{} = cater, attrs \\ %{}) do
    Cater.changeset(cater, attrs)
  end
end
