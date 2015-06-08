defmodule Wally.Mixfile do
  use Mix.Project

  def project do
    [app: :wally,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     name: "Wally",
     source_url: "https://github.com/avdgaag/wally",
     aliases: aliases]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Wally, []},
     applications: app_list(Mix.env)]
  end

  defp app_list do
    [:phoenix, :cowboy, :logger, :ecto, :comeonin]
  end

  defp app_list(:test) do
    [:hound | app_list]
  end

  defp app_list(_) do
    app_list
  end

  defp aliases do
    [compile: ["compile", &compile_assets/1]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.13"},
     {:phoenix_ecto, "~> 0.4"},
     {:phoenix_html, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_live_reload, "~> 0.4", only: :dev},
     {:cowboy, "~> 1.0"},
     {:hound, "~> 0.7", only: :test},
     {:comeonin, "~> 1.0"},
     {:ex_doc, "~> 0.7", only: :dev}]
  end

  defp compile_assets(_args) do
    case System.get_env("MIX_ENV") do
      "prod" ->
        System.cmd("npm", ["run", "compile"])
      _ ->
        # Nothing
    end
  end
end
