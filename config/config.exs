# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stats_app,
  ecto_repos: [StatsApp.Repo]

# Configures the endpoint
config :stats_app, StatsAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OpT7ENX5N3xBX5Fe7kObvDNlRmaB633it8TF0xkMszK9ZooGMxRMkJUQsDBXK2Bv",
  render_errors: [view: StatsAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: StatsApp.PubSub,
  live_view: [signing_salt: "rIluKMKn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
