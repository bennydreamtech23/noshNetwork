# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :noshNetwork,
  ecto_repos: [NoshNetwork.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :noshNetwork, NoshNetworkWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: NoshNetworkWeb.ErrorHTML, json: NoshNetworkWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: NoshNetwork.PubSub,
  live_view: [signing_salt: "jPdCLYex"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :noshNetwork, NoshNetwork.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
version: "3.4.3",
noshNetwork: [
  args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
  cd: Path.expand("../assets", __DIR__)
]

# Configures Elixir's Logger
config :logger,
  backends: [:console, {LoggerFileBackend, :file}],
  handlers: [{LoggerFileBackend, :file}]

config :logger, :file,
  path: "log/error_success.log",
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :user_id, :status]

# Set up a different log level for errors
config :logger, :error_file,
  path: "log/error.log",
  level: :error

# Add a custom logger for success
config :logger, :success_file,
  path: "log/success.log",
  level: :info

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :user_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
