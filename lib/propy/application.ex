defmodule Propy.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    port = Application.fetch_env!(:propy, :cowboy_port)
    Logger.info("Starting #{__MODULE__} Cowboy on port: #{port}...")

    children = [
      Propy.Repo,
      {Plug.Cowboy, scheme: :http, plug: Propy.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: Propy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
