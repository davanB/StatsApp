defmodule StatsApp.Repo do
  use Ecto.Repo,
    otp_app: :stats_app,
    adapter: Ecto.Adapters.Postgres
end
