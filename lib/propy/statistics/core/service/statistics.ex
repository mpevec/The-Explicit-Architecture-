defmodule Propy.Statistics.Core.Service.Statistics do
  @moduledoc """
  .
  """
  alias Propy.Statistics.Core.{IAdaptSystem, IManageStatistics}
  alias Propy.Statistics.Core.Service.IManageRepository
  alias Propy.Statistics.Core.Model.{ActiveAdAvgPriceM2, ActiveAdCommuneAggregates, ActiveAdCount,
    ActiveAdDate, CommuneAggregate, Zip}
  alias Propy.Statistics.Core.Service.Change

  @behaviour IManageStatistics

  @impl IManageStatistics
  def count(zip, weekly_increase)

  def count(zip, weekly_increase) when weekly_increase == true do
    with {:ok, count_before} <- active_ad_count(zip, IAdaptSystem.previous_week()),
      {:ok, count_now} <- active_ad_count(zip, IAdaptSystem.utc_now_as_date()),
      {:ok, change} <- Change.change_as_percentage(ActiveAdCount.value(count_before), ActiveAdCount.value(count_now))
    do
      {:ok, %{value: ActiveAdCount.value(count_now), change: change}}
    else
      err -> err
    end
  end

  def count(zip, _weekly_increase) do
    case active_ad_count(zip, IAdaptSystem.utc_now_as_date()) do
      {:ok, count} -> {:ok, %{value: ActiveAdCount.value(count), change: nil}}
      err -> err
    end
  end

  @impl IManageStatistics
  def avg_price_per_m2(zip, weekly_increase)

  def avg_price_per_m2(zip, weekly_increase) when weekly_increase == true do
    with {:ok, value_before} <- active_ad_avg_price_per_m2(zip, IAdaptSystem.previous_week()),
      {:ok, value_now} <- active_ad_avg_price_per_m2(zip, IAdaptSystem.utc_now_as_date()),
      {:ok, change} <- Change.change_as_percentage(ActiveAdAvgPriceM2.value(value_before), ActiveAdAvgPriceM2.value(value_now))
    do
      {:ok, %{value: ActiveAdAvgPriceM2.value(value_now), change: change}}
    else
      err -> err
    end
  end

  def avg_price_per_m2(zip, _weekly_increase) do
    case active_ad_avg_price_per_m2(zip, IAdaptSystem.utc_now_as_date()) do
      {:ok, value} -> {:ok, %{value: ActiveAdAvgPriceM2.value(value), change: nil}}
      err -> err
    end
  end

  @impl IManageStatistics
  def active_ad_commune_aggregates(zip, order) do
    with {:ok, zip} <- Zip.new(%{value: zip}),
      {:ok, active_ad_date} <- ActiveAdDate.new(%{to: IAdaptSystem.utc_now_as_date()}),
      {:ok, active_ad_commune_aggregates} <- ActiveAdCommuneAggregates.new(%{active_ad_date: active_ad_date, zip: zip, order: order}),
      {:ok, commune_aggregates} <- IManageRepository.commune_aggregates(active_ad_commune_aggregates),
      {:ok, active_ad_commune_aggregates} <- ActiveAdCommuneAggregates.upgrade(
        active_ad_commune_aggregates,
        commune_aggregates)
    do
      {:ok, Enum.map(ActiveAdCommuneAggregates.value(active_ad_commune_aggregates), fn a -> CommuneAggregate.to_map(a) end)}
    else
      err -> err
    end
  end

  defp active_ad_count(zip, to) do
    with {:ok, zip} <- Zip.new(%{value: zip}),
      {:ok, active_ad_date} <- ActiveAdDate.new(%{to: to}),
      {:ok, active_ad_count} <- ActiveAdCount.new(%{active_ad_date: active_ad_date, zip: zip}),
      {:ok, count} <- IManageRepository.ads_count(active_ad_count)
    do
      ActiveAdCount.upgrade(active_ad_count, count)
    else
      err -> err
    end
  end

  defp active_ad_avg_price_per_m2(zip, to) do
    with {:ok, zip} <- Zip.new(%{value: zip}),
      {:ok, active_ad_date} <- ActiveAdDate.new(%{to: to}),
      {:ok, active_ad_avg_price_m2} <- ActiveAdAvgPriceM2.new(%{active_ad_date: active_ad_date, zip: zip}),
      {:ok, price} <- IManageRepository.avg_price_per_m2(active_ad_avg_price_m2),
      {:ok, active_ad_avg_price_m2} <- ActiveAdAvgPriceM2.upgrade(active_ad_avg_price_m2, price)
    do
      {:ok, active_ad_avg_price_m2}
    else
      err -> err
    end
  end
end