defmodule Propy.Identity.Core.Model.ExpiryDate do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result

  defstruct [:utc_now, :expiry_in_minutes, :value]

  @opaque t :: %__MODULE__{
    utc_now: DateTime.t(),
    expiry_in_minutes: integer(),
    value: DateTime.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:utc_now, BuiltIn.datetime()},
      {:expiry_in_minutes, &parse_non_negative_numeric/1}],
      __MODULE__,
      params
    ) |> eval
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = expiry_date) do
    expiry_date
    |> Map.from_struct()
  end

  @spec value(t()) :: DateTime.t()
  def value(%__MODULE__{value: v}), do: v

  defp eval({:ok, %__MODULE__{} = expiry_date}) do
    value = expiry_date.utc_now |> DateTime.add(expiry_date.expiry_in_minutes * 60, :second)
    {:ok, %__MODULE__{expiry_date | value: value}}
  end

  defp eval({:error, _} = err), do: err

  defp parse_non_negative_numeric(value) do
    BuiltIn.integer().(value)
    |> Result.and_then(&non_negative/1)
  end

  defp non_negative(input) when input >= 0, do: Result.ok(input)
  defp non_negative(input), do: Result.error("not >= 0: #{input}")
end