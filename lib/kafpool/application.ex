defmodule Kafpool.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def pool_name do
    :worker_pool
  end

  defp poolboy_config do
    [{:name, {:local, pool_name()}},
     {:worker_module, Kafpool.Worker},
     {:size, 2},
     {:max_overflow, 50}]
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Kafpool.Worker.start_link(arg1, arg2, arg3)
      # worker(Kafpool.Worker, [arg1, arg2, arg3]),
      :poolboy.child_spec(pool_name(), poolboy_config(), [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kafpool.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
