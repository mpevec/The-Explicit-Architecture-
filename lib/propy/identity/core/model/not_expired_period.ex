defmodule Propy.Identity.Core.Model.NotExpiredPeriod do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result

  defstruct [:utc_now, :expire_in]

  @opaque t :: %__MODULE__{
    utc_now: DateTime.t(),
    expire_in: DateTime.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:utc_now, BuiltIn.datetime()},
      {:expire_in, BuiltIn.datetime()}],
      __MODULE__,
      params
    ) |> is_expired
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = not_expired_period) do
    not_expired_period
    |> Map.from_struct()
  end

  @spec expire_in(t()) :: DateTime.t()
  def expire_in(%__MODULE__{expire_in: ein}), do: ein

  defp is_expired({:ok, %__MODULE__{} = not_expired_period}) do
    case DateTime.compare(not_expired_period.expire_in, not_expired_period.utc_now) do
      :gt -> Result.ok(not_expired_period)
      _ -> Result.error("Model expired for expire_in: #{not_expired_period.expire_in}")
    end
  end
  defp is_expired({:error, _} = err), do: err
end