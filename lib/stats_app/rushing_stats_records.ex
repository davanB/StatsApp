defmodule StatsApp.RushingStatsRecords do
  import Ecto.Query, warn: false

  alias StatsApp.RushingStatsRecord
  alias StatsApp.Repo

  def get_rushing_stat_records(filters \\ %{}) do
    from(r in RushingStatsRecord)
    |> maybe_filter_by_name(filters)
    |> maybe_order_by(filters)
    |> Repo.all()
  end

  defp maybe_filter_by_name(query, %{player: player}) do
    from r in query,
      where: like(r.player, ^"#{player}%")
  end

  defp maybe_filter_by_name(query, _filters) do
    query
  end

  defp maybe_order_by(query, %{order_by: order_by}) when is_list(order_by) do
    from r in query,
      order_by: ^order_by
  end

  defp maybe_order_by(query, _filters) do
    query
  end

  @doc """
  Insert a record.
  We assume player, team and pos will be unique although there may be a case where it is not.
  Also keeping track of player number would make it unique but we assume this is good enough.
  """
  def insert_rushing_stat_record(record) do
    %RushingStatsRecord{}
    |> RushingStatsRecord.changeset(record)
    |> Repo.insert(
      on_conflict: :nothing,
      conflict_target: [:player, :team, :pos]
    )
  end
end
