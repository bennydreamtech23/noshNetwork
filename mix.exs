defmodule NoshNetwork.MixProject do
  use Mix.Project

  def project do
    [
      app: :noshNetwork,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {NoshNetwork.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7.9"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:cachex, "~> 4.0"},
      {:email_checker, "~> 0.1.3"},
      {:phoenix_pubsub, "~> 2.1"},
      {:premailex, "~> 0.3.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:floki, "~> 0.36.0"},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:heroicons,
      github: "tailwindlabs/heroicons",
      tag: "v2.1.1",
      sparse: "optimized",
      app: false,
      compile: false,
      depth: 1},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:logger_file_backend, "~> 0.0.10"},
      {:timex, "~> 3.0"},
      {:gettext, "~> 0.20"},
      {:number, "~> 1.0.1"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 2.1"},
      {:scrivener_ecto, "~> 2.7"},
      {:dns_cluster, "~> 0.1.1"},
      {:live_select, "~> 1.5"},
      {:plug_cowboy, "~> 2.5"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind noshNetwork", "esbuild noshNetwork"],
      "assets.deploy": ["tailwind noshNetwork --minify", "esbuild noshNetwork --minify", "phx.digest"]
    ]
  end
end
