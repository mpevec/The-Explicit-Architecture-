defmodule Propy.Statistics.Core.Model.ActiveAdDate do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result

  defstruct [:from, :to]

  @opaque t :: %__MODULE__{
    from: Date.t(),
    to: Date.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, any()}
  def new(params) do
    Data.Constructor.struct([
      {:to, BuiltIn.date()}],
      __MODULE__,
      params
    ) |> buffer_date
  end

  # we have 2 days as a buffer, as a reserve
  defp buffer_date({:ok, active_ad_date}) do
    from = Date.add(active_ad_date.to, -2)
    {:ok, %__MODULE__{active_ad_date | from: from}}
  end

  defp buffer_date({:error, _} = err), do: err

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = active_ad_date) do
    active_ad_date
    |> Map.from_struct()
  end

  @spec from(t()) :: Date.t()
  def from(%__MODULE__{from: f}), do: f

  @spec to(t()) :: Date.t()
  def to(%__MODULE__{to: t}), do: t

  def is_type(%__MODULE__{} = input), do: Result.ok(input)
  def is_type(input), do: Result.error("not a type #{__MODULE__}: #{input}")
end