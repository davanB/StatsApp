defmodule StatsAppWeb.RushingStatsLive do
  use StatsAppWeb, :live_view

  alias StatsApp.RushingStatsRecords
  alias StatsAppWeb.RushingStatsView
  alias StatsAppWeb.RushingStats.Form
  alias StatsApp.Downloader

  @sortable_fields ~w(Yds Lng TD)

  @impl true
  def mount(_params, _session, socket) do
    rows = if connected?(socket) do
      get_records_for_view()
    else
      []
    end

    changeset = Form.new()
    cols = RushingStatsView.headers()

    assigns = [
      cols: cols,
      changeset: changeset,
      rows: rows
    ]

    {:ok, assign(socket, assigns)}
  end

  def render_col(col, assigns) when col in @sortable_fields do
    ~L"""
    <th>
      <%= live_patch col, to: Routes.rushing_stats_path(@socket, __MODULE__, %{sort_by: col}) %><%= render_arrow(:down) %>
    </th>
    """
  end

  def render_col(col, assigns) do
    ~L"""
    <th><%= col %></th>
    """
  end

  def render_arrow(:down), do: "▼"
  def render_arrow(:up), do: "▲"

  @impl true
  def handle_params(params, _uri, socket) do
    IO.inspect(params)
    socket =
      case params["sort_by"] do
        sort_by when sort_by in @sortable_fields ->
          order_by = get_order_by(sort_by) |> IO.inspect()
          rows = get_records_for_view(%{order_by: order_by})
          assign(socket, rows: rows)

        _ ->
          socket
      end

    {:noreply, socket}
  end

  defp get_order_by("Yds"), do: [desc: :yds]
  defp get_order_by("Lng"), do: [desc: :lng]
  defp get_order_by("TD"), do: [desc: :td]

  def handle_event("filter_yds", _params, socket) do
    rows = get_records_for_view(%{order_by: [desc: :yds]})

    {:noreply, assign(socket, rows: rows)}
  end

  def handle_event("filter_lng", _params, socket) do
    rows = get_records_for_view(%{order_by: [desc: :lng]})

    {:noreply, assign(socket, rows: rows)}
  end

  def handle_event("filter_td", _params, socket) do
    rows = get_records_for_view(%{order_by: [desc: :td]})

    {:noreply, assign(socket, rows: rows)}
  end

  @impl true
  def handle_event("validate", %{"filters" => %{"player" => player_filter}}, socket) do
    cs =
      player_filter
      |> Form.validate()
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: cs)}
  end

  def handle_event("filter", %{"filters" => %{"player" => player_filter}}, socket) do
    rows = get_records_for_view(%{player: player_filter})

    {:noreply, assign(socket, rows: rows)}
  end

  def handle_event("reset_filter", _params, socket) do
    rows = get_records_for_view()

    changeset = Form.new()

    {:noreply, assign(socket, rows: rows, changeset: changeset)}
  end

  def handle_event("download_stats", _params, socket) do
    Downloader.download_records_async(socket, %{})

    {:noreply, socket}
  end

  defp get_records_for_view(filters \\ %{}) do
    RushingStatsRecords.get_rushing_stat_records(filters)
    |> RushingStatsView.transform_models_to_viewable_records()
  end
end
