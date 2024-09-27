defmodule NoshNetworkWeb.Plugs.UserAgentLogger do
  import Plug.Conn
  require Logger

  @doc """
  Logs the user agent of the incoming request.
  """
  def init(default), do: default

  def call(conn, _opts) do
    user_agent = get_req_header(conn, "user-agent") |> List.first()
    Logger.info("User agent: #{inspect(user_agent)}")
    conn
  end
end
