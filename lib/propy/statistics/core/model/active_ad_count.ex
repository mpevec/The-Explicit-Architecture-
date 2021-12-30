defmodule Propy.Statistics.Core.Model.ActiveAdCount do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias Propy.Statistics.Core.Model.{ActiveAdDate, Zip}

  defstruct [:value, :active_ad_date, :zip]

  @type value :: Decimal.t()

  @opaque t :: %__MODULE__{
    value: value,
    active_ad_date: ActiveAdDate.t(),
    zip: Zip.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:value, BuiltIn.integer(), default: nil},
      {:active_ad_date, &ActiveAdDate.is_type/1},
      {:zip, &Zip.is_type/1}],
      __MODULE__,
      params
    )
  end

  @spec upgrade(t(), value) :: {:ok, t()}
  def upgrade(%__MODULE__{} = active_ad_count, value) do
    {:ok, %__MODULE__{active_ad_count | value: value}}
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = active_ad_count) do
    active_ad_count
    |> Map.from_struct()
    |> Map.update!(:active_ad_date, &ActiveAdDate.to_map/1)
    |> Map.update!(:zip, &Zip.to_map/1)
  end

  @spec from(t()) :: Date.t()
  def from(%__MODULE__{active_ad_date: aad}), do: aad |> ActiveAdDate.from

  @spec to(t()) :: Date.t()
  def to(%__MODULE__{active_ad_date: aad}), do: aad |> ActiveAdDate.to

  @spec zip(t()) :: String.t() | nil
  def zip(%__MODULE__{zip: z}), do: z |> Zip.value

  @spec value(t()) :: value
  def value(%__MODULE__{value: v}), do: v
end