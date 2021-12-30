defmodule Propy.Identity.AuthorizationPlug do
  @moduledoc """
  .
  """
  import Plug.Conn

  alias Propy.Identity.Core.IManageIdentity

  @spec init(Keyword.t()) :: list()
  def init(opts) do
    Keyword.get(opts, :public_paths, [])
  end

  @spec call(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def call(conn, public_paths) do
    if skip_verification(conn.request_path, public_paths) do
      conn
    else
      with {:ok, token} <- extract_token(conn),
          {:ok, user_id} <- IManageIdentity.authenticate(token)
      do
        assign(conn, :current_user_id, user_id)
      else
        {:error, msg} -> send_resp(conn, :unauthorized, msg) |> halt()
      end
    end
  end

  defp skip_verification(request_path, public_paths) do
    Enum.member?(public_paths, request_path)
  end

  defp extract_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, "No authorization token found."}
    end
  end
end
