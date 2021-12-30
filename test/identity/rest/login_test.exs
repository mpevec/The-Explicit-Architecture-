defmodule Identity.Rest.LoginTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Plug.Test

  @options Propy.Router.init([])
  @route "/api/login"
  @response_cookie_name "refresh_token"

  defp setup_credentials(_) do
    {:ok, credentials: %{username: "..", password: ".."}}
  end

  defp setup_connection(%{credentials: credentials}) do
    conn = conn(:post, @route, credentials) |> put_req_header("content-type", "application/json")
    {:ok, conn: conn}
  end

  defp setup_impl(_) do
    # we should add also 'on_exit' to put values back
    Application.put_env(:propy, Propy.Identity.Core.IAdaptJwt, Identity.Rest.JwtAdapterTest)
    Application.put_env(:propy, Propy.Identity.Core.Service.IManageRepository, Identity.Rest.RepositoryAdapterTest)
    :ok
  end

  describe "Identity Context" do
    #arrange
    setup [:setup_credentials, :setup_connection, :setup_impl]

    test "User can login and JWT/refresh token are created", %{conn: conn} do
      # act
      conn = Propy.Router.call(conn, @options)

      # assert
      refresh_token = get_response_cookie(conn, @response_cookie_name)
      %{"jwt" => jwt} = get_json_response_body(conn)

      assert conn.state   == :sent
      assert conn.status  == 200
      assert String.length(refresh_token) > 0
      assert jwt == "a.b.c"
    end
  end

  defp get_response_cookie(%Plug.Conn{resp_cookies: cookies}, cookie), do: Map.get(cookies, cookie) |> Map.get(:value)
  defp get_json_response_body(%Plug.Conn{resp_body: body}), do: body |> Jason.decode!
end
