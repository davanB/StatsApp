defmodule StatsApp.Repo.Migrations.UnqiueConst do
  use Ecto.Migration

  def change do
    create unique_index(:rushing_stats_records, [:player, :team, :pos], name: :unique_player_index)
  end
end
