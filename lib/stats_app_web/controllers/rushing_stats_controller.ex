defmodule StatsAppWeb.RushingStatsController do
  use StatsAppWeb, :controller

  alias StatsApp.Downloader

  def export_stats(conn, params) do
    params = parse_params(params)
    task = Downloader.download_records_async(conn, params)

    case Task.yield(task) || Task.shutdown(task) do
      {:ok, done_conn} ->
        done_conn

      nil ->
        conn
    end
  end

  defp parse_params(params) do
    player = Map.get(params, "player")
    order_by = Map.get(params, "order_by")

    %{}
    |> maybe_add_key(:player, player)
    |> maybe_add_key(:order_by, order_by)
  end

  defp maybe_add_key(map, _key, nil), do: map
  defp maybe_add_key(map, key, value), do: Map.put(map, key, value)
end
