defmodule Propy.Statistics.Core.Service.IManageRepository do
  use Knigge,
    otp_app: :propy

  alias Propy.Statistics.Core.Model.{ActiveAdAvgPriceM2, ActiveAdCommuneAggregates, ActiveAdCount}

  @moduledoc false
  @callback ads_count(ActiveAdCount.t()) :: {:ok, ActiveAdCount.value()} | {:error, any()}
  @callback avg_price_per_m2(ActiveAdAvgPriceM2.t()) :: {:ok, ActiveAdAvgPriceM2.value()} | {:error, any()}
  @callback commune_aggregates(ActiveAdCommuneAggregates.t()) :: {:ok, ActiveAdCommuneAggregates.value()} | {:error, any()}

end