defmodule Gide do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, kafka_initial_offset) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Gide.Endpoint, []),
      # Start the Ecto repository
      worker(Gide.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Gide.Worker, [arg1, arg2, arg3]),
      supervisor(Kafka.Supervisor, [kafka_initial_offset]) # starts Kafka-consumer supervision tree
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gide.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Gide.Endpoint.config_change(changed, removed)
    :ok
  end
end
