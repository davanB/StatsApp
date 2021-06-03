defmodule StatsAppWeb.RushingStatsController do
  use StatsAppWeb, :controller

  alias StatsApp.Downloader

  def export_stats(conn, params) do
    Downloader.download_records(conn, %{})
  end
end
