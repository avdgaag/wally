use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :wally, Wally.Endpoint,
  secret_key_base: "LOgI/UwR6Jn9GSFksHd8YXG59WRe4/szRQ/BGOenaY5aqPkMIXHMMyrcdrZgjBjj"

# Configure your database
config :wally, Wally.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wally_prod"
