defmodule Homework.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger
  use Application

  def start(_type, _args) do
    # Print the env for troubleshooting purposes
    IO.inspect(Application.get_all_env(:homework))
    
    children = [
      # Start the Ecto repository
      Homework.Repo,
      # Start the Telemetry supervisor
      HomeworkWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Homework.PubSub},
      # Start the Endpoint (http/https)
      HomeworkWeb.Endpoint
      # Start a worker by calling: Homework.Worker.start_link(arg)
      # {Homework.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Homework.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HomeworkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
