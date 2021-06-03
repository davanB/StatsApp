defmodule StatsApp.Repo.Migrations.AddRushingStatsRecord do
  use Ecto.Migration

  def change do
    create table("rushing_stats_records") do
      add :player, :string
      add :team, :string
      add :pos, :string
      add :att, :integer
      add :att_g, :float
      add :yds, :integer
      add :avg, :float
      add :yds_g, :float
      add :td, :integer
      add :lng, :integer
      add :lng_t, :boolean
      add :first, :integer
      add :first_percentage, :float
      add :twenty_plus, :integer
      add :forty_plus, :integer
      add :fum, :integer
    end
  end
end
