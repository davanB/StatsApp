defmodule StatsApp.Downloader do
  alias StatsApp.RushingStatsRecords
  alias StatsApp.Writer
  alias StatsAppWeb.RushingStatsView

  @supervisor StatsApp.DownloadSupervisor

  def get_records_to_download(filters) do
    records =
      filters
      |> RushingStatsRecords.get_rushing_stat_records()
      |> RushingStatsView.transform_models_to_viewable_records()

    [RushingStatsView.headers() | records]
  end

  def download_records_async(socket, filters) do
    Task.Supervisor.start_child(@supervisor, __MODULE__, :download_records, [socket, filters])
  end

  def download_records(conn, filters) do
    Temp.track!()

    records = get_records_to_download(filters)

    {:ok, fd, file} = Temp.open()

    Writer.dump_to_file(file, records)
    conn = Phoenix.Controller.send_download(conn, {:file, file}, filename: "records.csv")

    File.close(fd)
    Temp.cleanup()

    conn
  end
end
