defmodule Propy.Statistics.Core.IManageStatistics do
  use Knigge,
    otp_app: :propy

  @moduledoc false

  @callback count(String.t(), boolean()) :: {:ok, map()} | {:error, any()}
  @callback avg_price_per_m2(String.t(), boolean()) :: {:ok, map()} | {:error, any()}
  @callback active_ad_commune_aggregates(String.t(), :asc | :desc) :: {:ok, list(map())} | {:error, any()}

end
