defmodule StatsApp.RushingStatsRecordsTest do
  use StatsApp.DataCase

  alias StatsApp.{RushingStatsRecords, RushingStatsRecord}

  test "can get all records" do
    assert RushingStatsRecords.get_rushing_stat_records() |> length() == 0

    TestUtils.create_test_record()

    assert RushingStatsRecords.get_rushing_stat_records() |> length() == 1
  end

  test "can filter by a portion of player name" do
    TestUtils.create_test_record(%{player: "Tony Soprano"})
    TestUtils.create_test_record(%{player: "Tony Jr Soprano"})

    records = RushingStatsRecords.get_rushing_stat_records(%{player: "Tony"})
    assert length(records) == 2

    player =
      %{player: "Tony Soprano"}
      |> RushingStatsRecords.get_rushing_stat_records()
      |> hd()

    assert player.player == "Tony Soprano"
  end

  test "can order by yds" do
    TestUtils.create_test_record(%{player: "Tony Soprano", yds: 10})
    TestUtils.create_test_record(%{player: "Tony Jr Soprano", yds: 20})

    records =
      RushingStatsRecords.get_rushing_stat_records(%{player: "Tony", order_by: [desc: :yds]})

    assert length(records) == 2
    [record_1, record_2] = records

    assert record_1.player == "Tony Jr Soprano"
    assert record_1.yds == 20
    assert record_2.player == "Tony Soprano"
    assert record_2.yds == 10
  end

  test "can order by lng" do
    TestUtils.create_test_record(%{player: "Tony Soprano", lng: 10})
    TestUtils.create_test_record(%{player: "Tony Jr Soprano", lng: 20})

    records =
      RushingStatsRecords.get_rushing_stat_records(%{player: "Tony", order_by: [desc: :lng]})

    assert length(records) == 2
    [record_1, record_2] = records

    assert record_1.player == "Tony Jr Soprano"
    assert record_2.player == "Tony Soprano"
  end

  test "can order by td" do
    TestUtils.create_test_record(%{player: "Tony Soprano", td: 10})
    TestUtils.create_test_record(%{player: "Tony Jr Soprano", td: 20})

    records =
      RushingStatsRecords.get_rushing_stat_records(%{player: "Tony", order_by: [desc: :td]})

    assert length(records) == 2
    [record_1, record_2] = records

    assert record_1.player == "Tony Jr Soprano"
    assert record_2.player == "Tony Soprano"
  end

  test "can order by yds, lng and td" do
    TestUtils.create_test_record(%{player: "Tony Soprano", yds: 10, lng: 10, td: 10})
    TestUtils.create_test_record(%{player: "Tony Jr Soprano", yds: 10, lng: 10, td: 20})
    TestUtils.create_test_record(%{player: "Tony Sr Soprano", yds: 10, lng: 20, td: 30})

    records =
      RushingStatsRecords.get_rushing_stat_records(%{
        player: "Tony",
        order_by: [desc: :yds, desc: :lng, desc: :td]
      })

    assert length(records) == 3
    [record_1, record_2, record_3] = records

    assert record_1.player == "Tony Sr Soprano"
    assert record_2.player == "Tony Jr Soprano"
    assert record_3.player == "Tony Soprano"
  end
end
