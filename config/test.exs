use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wally, Wally.Endpoint,
  http: [port: 4001],
  server: true

config :hound, driver: "phantomjs"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wally, Wally.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "wally_test",
  size: 1, # Use a single connection for transactional tests
  max_overflow: false,
  extensions: [{Wally.Jsonb.Extension, library: Poison}]
