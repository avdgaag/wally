defmodule Wally.Mixfile do
  use Mix.Project

  def project do
    [app: :wally,
     version: "0.0.1",
     elixir: "~> 1.0",
     name: "Wally",
     source_url: "https://github.com/avdgaag/wally",
     homepage_url: "https://avdgaag.github.io/wally",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Wally, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :exredis,
                    :tzdata, :oauth2]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.1"},
     {:exredis, ">= 0.0.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.3"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:timex, "~> 0.19.4"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.8", only: :dev},
     {:oauth2, "~> 0.3"}]
  end
end
