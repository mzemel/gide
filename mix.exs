defmodule Gide.Mixfile do
  use Mix.Project

  def project do
    [app: :gide,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(Mix.env)]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Gide, [0]}, applications: applications(Mix.env)]
  end

  defp applications(:test) do
    [:phoenix, :phoenix_html, :cowboy, :logger,
      :phoenix_ecto, :sqlite_ecto, :ecto]
  end
  defp applications(_) do
    [:phoenix, :phoenix_html, :cowboy, :logger,
      :phoenix_ecto, :postgrex, :kafka_ex, :snappy]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options

  defp deps(:test) do
    [{:phoenix, "~> 1.0.0"},
     {:phoenix_ecto, "~> 1.1.0"},
     {:postgrex, ">= 0.9.1"},
     {:phoenix_html, "~> 2.1.2"},
     {:cowboy, "~> 1.0.2"},
     {:sqlite_ecto, "~> 1.0.0"},
     {:exjsx, "~> 3.2.0"},
     {:kafka_ex, "~> 0.2.0"},
     {:junit_formatter, "~> 0.0.3"},
     {:pipe, "~> 0.0.2"},
     {:esqlite, "~> 0.2.1"},
     {:sqlitex, "~> 0.8.2"},
     {:decimal, "~> 1.1"}]
   end

  defp deps(_) do
    [{:phoenix, "~> 1.0.0"},
     {:phoenix_ecto, "~> 1.1.0"},
     {:postgrex, ">= 0.9.1"},
     {:phoenix_html, "~> 2.1.2"},
     {:phoenix_live_reload, "~> 1.0.0", only: :dev},
     {:cowboy, "~> 1.0.2"},
     {:kafka_ex, "~> 0.2.0"},
     {:snappy,
       git: "https://github.com/ricecake/snappy-erlang-nif",
       tag: "270fa36bee692c97f00c3f18a5fb81c5275b83a3"},
     {:exjsx, "~> 3.2.0"}]
  end
end
