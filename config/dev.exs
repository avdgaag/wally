use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with Webpack to recompile .js and .css sources.
config :wally, Wally.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: [
    {"npm", ["run", "compile:js:watch"]},
    {"npm", ["run", "compile:css:watch"]}
  ]

# Watch static and templates for browser reloading.
config :wally, Wally.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :wally, Wally.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "wally_dev",
  extensions: [{Wally.Jsonb.Extension, library: Poison}]
