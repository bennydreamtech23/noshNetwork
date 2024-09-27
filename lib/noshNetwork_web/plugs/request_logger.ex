defmodule NoshNetworkWeb.Plugs.RequestLogger do
  import Plug.Conn
  require Logger
  # Import your Users module to fetch user data
  alias NoshNetwork.Data.Context.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = fetch_session(conn)

    # Fetch the user token from the session
    user_token = get_session(conn, :user_token)

    # Use the token to get the user if available
    user = if user_token, do: Users.get_user_by_session_token(user_token), else: nil

    # Use user ID or "anonymous"
    user_id = (user && user.id) || "anonymous"
    request_path = conn.request_path
    method = conn.method
    timestamp = DateTime.utc_now()

    Logger.info("#{method} request to #{request_path} by User: #{user_id} at #{timestamp}")

    try do
      conn
      |> register_before_send(fn conn ->
        log_success(conn, user_id, method, request_path, timestamp)
        conn
      end)
    rescue
      e ->
        log_error(e, user_id, method, request_path, timestamp)
        conn
    end
  end

  defp log_success(conn, user_id, method, request_path, timestamp) do
    status = conn.status

    Logger.info("""
    #{method} request to #{request_path} by User: #{user_id} at #{timestamp} was successful.
    Status: #{status}
    """)
  end

  defp log_error(error, user_id, method, request_path, timestamp) do
    Logger.error("""
    Error occurred during #{method} request to #{request_path} by User: #{user_id} at #{timestamp} was unsuccessful.
    Error details: #{inspect(error)}
    """)
  end
end
