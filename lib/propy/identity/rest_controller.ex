defmodule Propy.Identity.RestController do
  @moduledoc """
  .
  """
  import Plug.Conn
  require Logger

  alias Propy.Identity.Core.IManageIdentity

  @spec login(Plug.Conn.t()) :: Plug.Conn.t()
  def login(conn) do
    case IManageIdentity.login(conn.body_params) do
      {:ok, res} ->
        conn = put_resp_cookie(conn, "refresh_token", res.refresh_token)
        send_resp(conn, :ok, Jason.encode!(%{jwt: res.token}))
      {:error, err} ->
        log_err(err)
        send_resp(conn, :unauthorized, "Error logging in.")
    end
  end

  @spec silent_login(Plug.Conn.t()) :: Plug.Conn.t()
  def silent_login(conn) do
    conn = fetch_cookies(conn)
    refresh_token_value = get_request_cookie(conn, "refresh_token")

    case IManageIdentity.silent_login(refresh_token_value) do
      {:ok, res} ->
        conn = put_resp_cookie(conn, "refresh_token", res.refresh_token)
        send_resp(conn, :ok, Jason.encode!(%{jwt: res.token}))
      {:error, err} ->
        log_err(err)
        send_resp(conn, :unauthorized, "Error with silent login.")
    end
  end

  defp get_request_cookie(%Plug.Conn{cookies: cookies}, cookie) do
    Map.get(cookies, cookie)
  end

  defp log_err(err), do: Logger.info("#{__MODULE__} error: #{inspect(err)}")
end
