use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :gide, Gide.Endpoint,
  secret_key_base: {:system, "SECRET_KEY_BASE"}

# Configure your database
config :gide, Gide.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  size: 20 # The amount of database connections in the pool
