defmodule StatsApp.RushingStatsRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushing_stats_records" do
    field :player, :string
    field :team, :string
    field :pos, :string
    field :att, :integer
    field :att_g, :float
    field :yds, :integer
    field :avg, :float
    field :yds_g, :float
    field :td, :integer
    field :lng, :integer
    field :lng_t, :boolean
    field :first, :integer
    field :first_percentage, :float
    field :twenty_plus, :integer
    field :forty_plus, :integer
    field :fum, :integer
  end

  def changeset(%__MODULE__{} = record, attrs \\ %{}) do
    fields = __schema__(:fields) -- [:id]

    record
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
