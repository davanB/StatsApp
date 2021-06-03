defmodule TestUtils do
  def create_test_record(attrs \\ %{}) do
    {:ok, record} =
      %{
        player: "Mark Ingram",
        team: "NO",
        pos: "RB",
        att: 205,
        att_g: 12.8,
        yds: 1043,
        avg: 5.1,
        yds_g: 65.2,
        td: 6,
        lng: 75,
        lng_t: true,
        first: 49,
        first_percentage: 23.9,
        twenty_plus: 4,
        forty_plus: 2,
        fum: 2
      }
      |> Map.merge(attrs)
      |> StatsApp.RushingStatsRecords.insert_rushing_stat_record()

    record
  end
end
