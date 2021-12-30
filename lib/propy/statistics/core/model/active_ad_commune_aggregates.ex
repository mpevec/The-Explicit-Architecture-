defmodule Propy.Statistics.Core.Model.ActiveAdCommuneAggregates do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result
  alias Propy.Statistics.Core.Model.{ActiveAdDate, CommuneAggregate, Zip}

  defstruct [:value, :active_ad_date, :zip, :order, :limit]

  @type value :: list(CommuneAggregate.t())
  @type order :: :asc | :desc

  @opaque t :: %__MODULE__{
    value: value,
    active_ad_date: ActiveAdDate.t(),
    zip: Zip.t(),
    order: order,
    limit: integer(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:value, &is_type_list/1, default: nil},
      {:active_ad_date, &ActiveAdDate.is_type/1},
      {:zip, &Zip.is_type/1},
      {:order, BuiltIn.atom()},
      {:limit, BuiltIn.integer(), default: 5}],
      __MODULE__,
      params
    )
  end

  @spec upgrade(t(), value) :: {:ok, t()}
  def upgrade(%__MODULE__{} = input, value) do
    {:ok, %__MODULE__{input | value: value}}
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = active_ad_count) do
    active_ad_count
    |> Map.from_struct()
    |> Map.update!(:active_ad_date, &ActiveAdDate.to_map/1)
    |> Map.update!(:zip, &Zip.to_map/1)
  end

  @spec order(t()) :: order
  def order(%__MODULE__{order: o}), do: o

  @spec limit(t()) :: integer()
  def limit(%__MODULE__{limit: l}), do: l

  @spec value(t()) :: value
  def value(%__MODULE__{value: v}), do: v

  @spec from(t()) :: Date.t()
  def from(%__MODULE__{active_ad_date: aad}), do: aad |> ActiveAdDate.from

  @spec to(t()) :: Date.t()
  def to(%__MODULE__{active_ad_date: aad}), do: aad |> ActiveAdDate.to

  @spec zip(t()) :: String.t() | nil
  def zip(%__MODULE__{zip: z}), do: z |> Zip.value

  defp is_type_list(value) when is_list(value), do: Result.ok(value)
  defp is_type_list(value), do: Result.error("not a list: #{inspect value}")
end