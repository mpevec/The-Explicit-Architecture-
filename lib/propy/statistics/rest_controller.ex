defmodule Propy.Statistics.RestController do
  @moduledoc """
  .
  """
  import Plug.Conn
  require Logger
  alias Propy.Statistics.Core.IManageStatistics

  def count(conn) do
    fetch_query_params(conn)
    weekly_increase = get_query_param(conn, "weekly_increase", &to_boolean/1)
    zip = get_query_param(conn, "zip")

    case IManageStatistics.count(zip, weekly_increase) do
      {:ok, result} ->
        send_resp(conn, :ok, Jason.encode!(%{value: result.value, change: Decimal.round(result.change, 2)}))
      {:error, err} ->
        log_err(err)
        send_resp(conn, :internal_server_error, "Error getting count.")
    end
  end

  def avg_price_per_m2(conn) do
    fetch_query_params(conn)
    weekly_increase = get_query_param(conn, "weekly_increase", &to_boolean/1)
    zip = get_query_param(conn, "zip")

    case IManageStatistics.avg_price_per_m2(zip, weekly_increase) do
      {:ok, result} ->
        send_resp(conn, :ok, Jason.encode!(%{value: result.value, change: Decimal.round(result.change, 2)}))
      {:error, err} ->
        log_err(err)
        send_resp(conn, :internal_server_error, "Error getting average price per m2.")
    end
  end

  def commune_aggregates(conn) do
    fetch_query_params(conn)
    zip = get_query_param(conn, "zip")
    order = get_query_param(conn, "ord", &to_order/1)

    case IManageStatistics.active_ad_commune_aggregates(zip, order) do
      {:ok, result} -> send_resp(conn, :ok, Jason.encode!(result))
      {:error, err} ->
        log_err(err)
        send_resp(conn, :internal_server_error, "Error getting commune aggregates.")
    end
  end

  defp get_query_param(%Plug.Conn{query_params: query_params}, param), do: Map.get(query_params, param)
  defp get_query_param(%Plug.Conn{query_params: query_params}, param, converter), do: Map.get(query_params, param) |> converter.()
  defp to_boolean("true"), do: true
  defp to_boolean("false"), do: false
  defp to_boolean(_), do: nil
  defp to_order("1"), do: :desc
  defp to_order("2"), do: :asc
  defp log_err(err), do: Logger.info("#{__MODULE__} error: #{inspect(err)}")
end
