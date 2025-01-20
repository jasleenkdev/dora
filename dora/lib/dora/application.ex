defmodule Dora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DoraWeb.Telemetry,
      Dora.Repo,
      {DNSCluster, query: Application.get_env(:dora, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Dora.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dora.Finch},
      # Start a worker by calling: Dora.Worker.start_link(arg)
      # {Dora.Worker, arg},
      # Start to serve requests, typically the last entry
      DoraWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DoraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
