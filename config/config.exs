# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :gide, Gide.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "BVbcjB4oQ1baaD+0PncDRmqZDYFBDDiZ7MhC8xKRXW++sLH6wNvorPnS/sW1I1qA",
  debug_errors: false,
  pubsub: [name: Gide.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# I don't really get how docker-compose linking works.
# Inspecting the ENVs gives me a KAFKA_PORT variable that looks like something parseable
kafka_broker = System.get_env("KAFKA_PORT") || "tcp://192.168.59.103:9092"

kafka_host = kafka_broker |> URI.parse |> Map.fetch!(:host)
kafka_port = kafka_broker |> URI.parse |> Map.fetch!(:port)

config :kafka_ex, brokers: [{kafka_host, kafka_port}]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"