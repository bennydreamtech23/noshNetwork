defmodule NoshNetwork.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NoshNetwork.Repo,
      NoshNetworkWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:noshNetwork, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NoshNetwork.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: NoshNetwork.Finch},
      # Start a worker by calling: NoshNetwork.Worker.start_link(arg)
      # {NoshNetwork.Worker, arg},
      # Start to serve requests, typically the last entry
      NoshNetworkWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NoshNetwork.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NoshNetworkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
