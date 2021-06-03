defmodule StatsApp.SeedTest do
  use StatsApp.DataCase

  alias StatsApp.Repo
  alias StatsApp.RushingStatsRecord

  @total_record_count 326

  test "can seed rushing.json" do
    assert Repo.all(RushingStatsRecord) |> length() == 0

    priv_dir = :code.priv_dir(:stats_app)
    seed_file = "#{priv_dir}/repo/seeds.exs"
    Code.eval_file(seed_file)

    assert Repo.all(RushingStatsRecord) |> length() == @total_record_count

    player = Repo.get_by(RushingStatsRecord, player: "Jeremy Hill")
    assert player != nil
    assert player.lng == 74
    assert player.lng_t == true
  end
end
