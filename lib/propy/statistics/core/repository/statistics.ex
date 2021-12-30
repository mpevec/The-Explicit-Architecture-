defmodule Propy.Statistics.Core.Repository.Statistics do
  @moduledoc """
  .
  """
  import Ecto.Query
  import Propy.QueryFragment

  alias Propy.Repo
  alias Propy.Statistics.Core.Service.IManageRepository
  alias Propy.Statistics.Core.Model.{ActiveAdAvgPriceM2, ActiveAdCommuneAggregates, ActiveAdCount, CommuneAggregate}
  alias Propy.Statistics.Core.Repository.Schema.{PropertyAd, ZipCode}

  @behaviour IManageRepository

  @impl IManageRepository
  def ads_count(active_ad_count) do
    zip = ActiveAdCount.zip(active_ad_count)
    from = ActiveAdCount.from(active_ad_count)
    to = ActiveAdCount.to(active_ad_count)

    query = case zip do
              nil -> ads_count_as_query(from, to)
              _ -> from [p, z] in ads_count_as_query(from, to),
                  where: z.code == ^zip
            end

    Repo.fetch_one(query)
  end

  @impl IManageRepository
  def avg_price_per_m2(active_ad_avg_price_m2) do
    zip = ActiveAdAvgPriceM2.zip(active_ad_avg_price_m2)
    from = ActiveAdAvgPriceM2.from(active_ad_avg_price_m2)
    to = ActiveAdAvgPriceM2.to(active_ad_avg_price_m2)

    query = if zip != nil do
              from [p, z] in avg_price_per_m2_as_query(from, to),
              where: z.code == ^zip
            else
              avg_price_per_m2_as_query(from, to)
            end

    Repo.fetch_one(query)
  end

  @impl IManageRepository
  def commune_aggregates(active_ad_commune_aggregates) do
    from = ActiveAdCommuneAggregates.from(active_ad_commune_aggregates)
    to = ActiveAdCommuneAggregates.to(active_ad_commune_aggregates)
    zip = ActiveAdCommuneAggregates.zip(active_ad_commune_aggregates)
    order = ActiveAdCommuneAggregates.order(active_ad_commune_aggregates)
    limit = ActiveAdCommuneAggregates.limit(active_ad_commune_aggregates)

    query = if zip != nil do
              from [p, z] in commune_aggregates_as_query(from, to, order, limit),
              where: z.code == ^zip
            else
              commune_aggregates_as_query(from, to, order, limit)
            end

    Repo.all(query)
    |> Enum.map(fn r -> to_commune_aggregate(r) end)
    |> Enum.split_with(fn r -> case r do
                            {:error, _} -> true # if contains {:error, _} then put it in the errors list
                            _ -> false # else put it into the success list
                            end
                      end)
    |> case do
      {[], only_okeys} -> # all converted elements were okeys, we are all good
        {:ok, Enum.map(only_okeys, fn {:ok, aggregate} -> aggregate end)}
      {errors, _} -> # at least one error, not good
        {:error, errors}
    end
  end

  defp ads_count_as_query(from, to) do
    from p in PropertyAd,
    join: z in ZipCode, on: z.id_zip_code == p.id_zip_code,
    where: p.last_date_checked >= to_date(^from)
    and p.last_date_checked <= to_date(^to),
    select: count(p.id_property_ad)
  end

  defp avg_price_per_m2_as_query(from, to) do
    from p in PropertyAd,
    join: z in ZipCode, on: z.id_zip_code == p.id_zip_code,
    where: p.last_date_checked >= to_date(^from)
    and p.last_date_checked <= to_date(^to),
    select: coalesce(avg(p.price/p.size), 0)
  end

  defp commune_aggregates_as_query(from, to, ord, limit) do
    from p in PropertyAd,
    join: z in ZipCode, on: z.id_zip_code == p.id_zip_code,
    where: p.last_date_checked >= to_date(^from)
    and p.last_date_checked <= to_date(^to),
    group_by: p.title,
    order_by: [{^ord, avg(p.price/p.size)}],
    limit: ^limit,
    select: %{
      commune: p.title,
      avgpm2: coalesce(avg(p.price/p.size), 0),
      avgm2: coalesce(avg(p.size), 0),
      noads: count(p.id_property_ad),
    }
  end

  defp to_commune_aggregate(%{commune: commune, avgpm2: avgpm2, avgm2: avgm2, noads: noads}) do
    CommuneAggregate.new(%{commune: commune, avgpm2: avgpm2, avgm2: avgm2, noads: noads})
  end
end