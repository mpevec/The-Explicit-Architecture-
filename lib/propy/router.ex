defmodule Propy.Router do
  @moduledoc """
    Basic router for this app
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  alias Propy.{Identity, Statistics}
  alias Propy.Identity.AuthorizationPlug
  import Plug.Conn

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(AuthorizationPlug, public_paths: ["/api/ping", "/api/login", "/api/login/refresh_token"])
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/api/ping", do: send_resp(conn, :ok, "ping ok")
  post "/api/login", do: Identity.RestController.login(conn)
  get "/api/login/refresh_token", do: Identity.RestController.silent_login(conn)
  get "/api/statistics/count", do: Statistics.RestController.count(conn)
  get "/api/statistics/avg_price_per_m2", do: Statistics.RestController.avg_price_per_m2(conn)
  get "/api/statistics/commune/aggregates", do: Statistics.RestController.commune_aggregates(conn)

  match _ do
    send_resp(conn, :not_found, "")
  end
end
