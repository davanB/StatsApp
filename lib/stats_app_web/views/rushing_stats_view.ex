defmodule StatsAppWeb.RushingStatsView do
  use StatsAppWeb, :view

  @fields [
    "Player",
    "Team",
    "Pos",
    "Att",
    "Att/G",
    "Yds",
    "Avg",
    "Yds/G",
    "TD",
    "Lng",
    "1st",
    "1st%",
    "20+",
    "40+",
    "FUM"
  ]

  def headers(), do: @fields

  def transform_models_to_viewable_records(records) when is_list(records) do
    Enum.map(records, &transform_models_to_viewable_records/1)
  end

  def transform_models_to_viewable_records(record) do
    [
      record.player,
      record.team,
      record.pos,
      record.att,
      record.att_g,
      record.yds,
      record.avg,
      record.yds_g,
      record.td,
      get_lng(record.lng, record.lng_t),
      record.first,
      record.first_percentage,
      record.twenty_plus,
      record.forty_plus,
      record.fum
    ]
  end

  def get_lng(lng, true = _lng_t), do: "#{lng}T"
  def get_lng(lng, false = _lng_t), do: "#{lng}"
end
