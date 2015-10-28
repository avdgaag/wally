use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :wally, Wally.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [
    {"npm", ["run", "compile:js:watch"]},
    {"npm", ["run", "compile:css:watch"]}
  ]

# Watch static and templates for browser reloading.
config :wally, Wally.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

config :wally, :oauth,
  client_id: "625826228011-0u212h65bec52jg7p32ddumkp2dakd4v.apps.googleusercontent.com",
  client_secret: "24QzcAvXO_Zi3SmzGEG--k6q",
  redirect_uri: "http://localhost:4000/auth/google/callback",
  domain: "brightin.nl"
