defmodule NoshNetworkWeb.Services.Cache do
  @moduledoc """
  false
  """
  @cache_name :foodies_cache

  def get_user_notifications(user_id) do
    user_id
    |> user_notification_key()
    |> get_items()
  end

  def put_user_notification(user_id, alert) do
    user_id
    |> user_notification_key()
    |> put_item(alert)
  end

  defp put_item(key, item, ttl \\ :timer.hours(24)) do
    unique_id = generate_unique_id()
    Cachex.put(@cache_name, unique_id, item, ttl: ttl)

    case Cachex.exists?(@cache_name, key) do
      {:ok, false} ->
        Cachex.put(@cache_name, key, [unique_id], ttl: ttl)

      {:ok, true} ->
        Cachex.get_and_update(@cache_name, key, fn ids -> [unique_id | ids] end, ttl: ttl)
    end
  end

  defp get_items(key) do
    get_ids(key)
    |> Enum.map(&get_item(&1))
  end

  defp get_item(unique_id) do
    Cachex.get!(@cache_name, unique_id)
  end

  defp get_ids(key) do
    case Cachex.get(@cache_name, key) do
      {:ok, nil} ->
        []

      {:ok, ids} ->
        ids
    end
  end

  defp generate_unique_id(), do: "#{:erlang.system_time(:microsecond)}_#{:rand.uniform()}"

  defp user_notification_key(user_id), do: "#{user_id}_alerts" |> String.to_atom()
end
