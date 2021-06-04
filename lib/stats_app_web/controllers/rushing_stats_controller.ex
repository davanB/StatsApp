defmodule StatsAppWeb.RushingStatsController do
  use StatsAppWeb, :controller

  alias StatsApp.Downloader

  def export_stats(conn, params) do
    parsed_params =
      params
      |> Map.take(["player_filter", "order_by"])
      |> parse_params()

    Downloader.download_records_async(conn, parsed_params)
  end

  defp parse_params(params) do
    player = Map.get(params, "player_filter")

    order_by =
      params
      |> Map.get("order_by")
      |> Enum.map(fn {col, order} ->
        col = String.downcase(col)
        {String.to_existing_atom(order), String.to_existing_atom(col)}
      end)
      |> Keyword.new()

    %{}
    |> maybe_add_key(:player, player)
    |> maybe_add_key(:order_by, order_by)
  end

  defp maybe_add_key(map, _key, nil), do: map
  defp maybe_add_key(map, key, value), do: Map.put(map, key, value)
end
