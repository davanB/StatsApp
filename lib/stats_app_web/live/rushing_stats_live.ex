defmodule StatsAppWeb.RushingStatsLive do
  use StatsAppWeb, :live_view

  alias StatsApp.RushingStatsRecords
  alias StatsAppWeb.RushingStatsView
  alias StatsAppWeb.RushingStats.Form

  @sortable_fields ~w(Yds Lng TD)

  @order_states %{
    none: :desc,
    desc: :asc,
    asc: :desc
  }

  @sortable_col_index %{
    "Yds" => 5,
    "TD" => 8,
    "Lng" => 9
  }

  @impl true
  def mount(_params, _session, socket) do
    rows =
      if connected?(socket) do
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
      <%= live_patch col, to: Routes.rushing_stats_path(@socket, __MODULE__, %{order_by: col}), replace: true %><%= maybe_render_arrow(col, assigns) %>
    </th>
    """
  end

  def render_col(col, assigns) do
    ~L"""
    <th><%= col %></th>
    """
  end

  def maybe_render_arrow(curr_col, %{order_by: %{col: col, direction: direction}})
      when curr_col == col,
      do: render_arrow(direction)

  def maybe_render_arrow(_curr_col, _assigns), do: render_arrow(:none)

  def render_arrow(:desc), do: "▼"
  def render_arrow(:asc), do: "▲"
  def render_arrow(:none), do: ""

  def handle_params(%{"player_filter" => filter}, _uri, socket) do
    order_by = get_order_by(socket.assigns.order_by)
    rows = get_records_for_view(%{player: filter, order_by: order_by})

    {:noreply, assign(socket, rows: rows, player_filter: filter)}
  end

  @impl true
  def handle_params(%{"order_by" => order_by}, _uri, socket) when order_by in @sortable_fields do
    assigns = socket.assigns
    order_by_state = assigns.order_by
    new_order_by_state = update_order_by_state(order_by, order_by_state)

    rows = sort_rows_by_col(assigns.rows, new_order_by_state)

    {:noreply, assign(socket, rows: rows, order_by: new_order_by_state)}
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

  @impl true
  def handle_event("validate", %{"filters" => %{"player" => player_filter}}, socket) do
    cs =
      player_filter
      |> Form.validate()
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: cs)}
  end

  def handle_event("filter", %{"filters" => %{"player" => player_filter}}, socket) do
    params = %{player_filter: player_filter}

    {:noreply, push_patch(socket, to: Routes.rushing_stats_path(socket, __MODULE__, params))}
  end

  def handle_event("reset_filter", _params, socket) do
    {:noreply, push_patch(socket, to: Routes.rushing_stats_path(socket, __MODULE__))}
  end

  def handle_event("download_stats", _params, socket) do
    assigns = socket.assigns
    %{col: col, direction: direction} = assigns.order_by

    params = %{
      player_filter: assigns.player_filter,
      order_by: %{col => direction}
    }

    {:noreply, redirect(socket, to: Routes.rushing_stats_path(socket, :export_stats, params))}
  end

  defp get_order_by(%{col: col, direction: direction}) when direction != :none do
    col =
      col
      |> String.downcase()
      |> String.to_existing_atom()

    Keyword.new([{direction, col}])
  end

  defp get_order_by(_order_by), do: []

  defp update_order_by_state(order_by, %{col: col, direction: old_direction})
       when order_by == col do
    %{
      col: col,
      direction: Map.get(@order_states, old_direction)
    }
  end

  defp update_order_by_state(order_by, _old_state) do
    %{
      col: order_by,
      direction: :desc
    }
  end

  defp sort_rows_by_col(rows, %{col: "Lng" = col, direction: direction})
       when direction != :none do
    Enum.sort_by(
      rows,
      fn row ->
        row
        |> get_col_from_row(col)
        |> try_parse_int()
      end,
      direction
    )
  end

  defp sort_rows_by_col(rows, %{col: col, direction: direction})
       when direction != :none and col != "Lng" do
    Enum.sort_by(rows, &get_col_from_row(&1, col), direction)
  end

  defp sort_rows_by_col(rows, _), do: rows

  defp get_col_from_row(row, col) do
    index = Map.get(@sortable_col_index, col)
    Enum.at(row, index)
  end

  defp try_parse_int(lng) when is_binary(lng) do
    lng
    |> Integer.parse()
    |> elem(0)
  end

  defp try_parse_int(lng), do: lng

  defp get_records_for_view(filters \\ %{}) do
    RushingStatsRecords.get_rushing_stat_records(filters)
    |> RushingStatsView.transform_models_to_viewable_records()
  end
end
