defmodule NoshNetworkWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics
  alias NoshNetwork.Repo
  # Assuming this is your user schema module
  alias NoshNetwork.Data.Schema.User

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Define the metrics to be collected
  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.start.system_time", unit: {:native, :millisecond}),
      summary("phoenix.endpoint.stop.duration", unit: {:native, :millisecond}),
      summary("phoenix.router_dispatch.start.system_time",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.exception.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.socket_connected.duration", unit: {:native, :millisecond}),
      summary("phoenix.channel_joined.duration", unit: {:native, :millisecond}),
      summary("phoenix.channel_handled_in.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("noshNetwork.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The total query execution time"
      ),
      summary("noshNetwork.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding data"
      ),
      summary("noshNetwork.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The actual query execution time"
      ),
      summary("noshNetwork.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "Time spent waiting for a database connection"
      ),
      summary("noshNetwork.repo.query.idle_time",
        unit: {:native, :millisecond},
        description: "Idle connection time before query execution"
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io"),

      # User Activity Count Metric
      summary("noshNetworkWeb.user_activity.count",
        unit: :integer,
        description: "Active users in the system"
      ),
      # Error and Success Metrics
      summary("phoenix.error_rendered.duration",
        unit: {:native, :millisecond},
        description: "Duration to render errors"
      ),
      counter("phoenix.error_rendered.count",
        description: "Counts the number of errors rendered"
      ),
      # Add transaction logging metrics
      summary("noshNetwork.transactions.duration", unit: {:native, :millisecond}),
      counter("noshNetwork.transactions.count")
    ]
  end

  # Periodic measurements - includes count_users
  defp periodic_measurements do
    [
      {__MODULE__, :count_users, []}
    ]
  end

  # Count the active users in the system and send a telemetry event
  def count_users do
    # Adjust based on your user schema
    user_count = Repo.aggregate(User, :count, :id)
    :telemetry.execute([:noshNetworkWeb, :user_activity], %{count: user_count}, %{})
  end
end
