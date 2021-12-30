defmodule Propy.Statistics.Core.Model.CommuneAggregate do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result
  require Decimal

  defstruct [:commune, :avgpm2, :avgm2, :noads]

  @opaque t :: %__MODULE__{
    commune: String.t(),
    avgpm2: Decimal.t(),
    avgm2: Decimal.t(),
    noads: integer(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:commune, BuiltIn.string()},
      {:avgpm2, &parse_decimal/1},
      {:avgm2, &parse_decimal/1},
      {:noads, BuiltIn.integer()}],
      __MODULE__,
      params
    )
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = ad_commune_aggregate) do
    ad_commune_aggregate
    |> Map.from_struct()
  end

  defp parse_decimal(input) do
    if Decimal.is_decimal(input) do
      Result.ok(input)
    else
      Result.error("not a decimal: #{input}")
    end
  end
end