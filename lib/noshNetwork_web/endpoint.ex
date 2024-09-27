defmodule NoshNetworkWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :noshNetwork

  # The session will be stored in the cookie and signed
  @session_options [
    store: :cookie,
    key: "_noshNetwork_key",
    signing_salt: "ow2jX8TS",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :noshNetwork,
    gzip: false,
    only: NoshNetworkWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :noshNetwork
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # Initialize the session before using RequestLogger
  plug Plug.Session, @session_options

  # Move the RequestLogger after Plug.Session
  plug NoshNetworkWeb.Plugs.RequestLogger

  plug NoshNetworkWeb.Router
end
