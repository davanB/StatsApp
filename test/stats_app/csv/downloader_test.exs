defmodule StatsApp.DownloaderTest do
  use StatsApp.DataCase

  alias StatsApp.Downloader

  test "can convert records to csv rows" do
    TestUtils.create_test_record(%{player: "Joe Malone", td: 1000})

    rows = Downloader.get_records_to_download(%{})
    assert length(rows) == 2
    assert hd(rows) == StatsAppWeb.RushingStatsView.headers()

    td =
      rows
      |> tl()
      |> hd()
      |> Enum.at(8)

    assert td == 1000
  end
end
