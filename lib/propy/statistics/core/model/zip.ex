defmodule Propy.Statistics.Core.Model.Zip do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result

  defstruct [:value]

  @opaque t :: %__MODULE__{
    value: String.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:value, BuiltIn.string(), default: nil}],
      __MODULE__,
      params
    )
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = zip) do
    zip
    |> Map.from_struct()
  end

  def value(%__MODULE__{value: v}), do: v

  def is_type(%__MODULE__{} = input), do: Result.ok(input)
  def is_type(input), do: Result.error("not a type #{__MODULE__}: #{input}")
end