defmodule StatsAppWeb.RushingStatsLive do
  use StatsAppWeb, :live_view

  alias StatsApp.RushingStatsRecords
  alias StatsAppWeb.RushingStatsView
  alias StatsAppWeb.RushingStats.Form
  alias StatsApp.Downloader

  @sortable_fields ~w(Yds Lng TD)

  @order_states %{
    none: :desc,
    desc: :asc,
    asc: :none
  }

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
      rows: rows,
      player_filter: "",
      order_by: %{
        col: "",
        direction: :none
      }
    ]

    {:ok, assign(socket, assigns)}
  end

  def render_col(col, assigns) when col in @sortable_fields do
    ~L"""
    <th>
      <%= live_patch col, to: Routes.rushing_stats_path(@socket, __MODULE__, %{sort_by: col}), replace: true %><%= maybe_render_arrow(col, assigns) %>
    </th>
    """
  end

  def render_col(col, assigns) do
    ~L"""
    <th><%= col %></th>
    """
  end

  def maybe_render_arrow(curr_col, %{order_by: %{col: col, direction: direction}}) when curr_col == col , do: render_arrow(direction)
  def maybe_render_arrow(_curr_col, _assigns), do: render_arrow(:none)

  def render_arrow(:down), do: "▼"
  def render_arrow(:up), do: "▲"
  def render_arrow(:none), do: ""

  @impl true
  def handle_params(%{"sort_by" => sort_by}, _uri, socket) when sort_by in @sortable_fields do
    order_by = get_order_by(sort_by)
    rows = get_records_for_view(%{order_by: order_by})

    {:noreply, assign(socket, rows: rows)}
  end

  def handle_params(params, _uri, socket) when params == %{} do
    rows = get_records_for_view()

    assigns = [
      rows: rows,
      player_filter: "",
      order_by: %{
        col: "",
        direction: :none
      }
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp get_order_by("Yds"), do: [desc: :yds]
  defp get_order_by("Lng"), do: [desc: :lng]
  defp get_order_by("TD"), do: [desc: :td]

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

    {:noreply, assign(socket, rows: rows, player_filter: player_filter)}
  end

  def handle_event("reset_filter", _params, socket) do
    {:noreply, push_patch(socket, to: Routes.rushing_stats_path(socket, __MODULE__))}
  end

  def handle_event("download_stats", _params, socket) do
    assigns = socket.assigns
    params = %{
      player: assigns.player_filter
    }

    {:noreply, redirect(socket, to: Routes.rushing_stats_path(socket, :export_stats, params))}
  end

  defp get_records_for_view(filters \\ %{}) do
    RushingStatsRecords.get_rushing_stat_records(filters)
    |> RushingStatsView.transform_models_to_viewable_records()
  end
end
