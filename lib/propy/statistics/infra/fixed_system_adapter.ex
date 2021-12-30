defmodule Propy.Statistics.Infra.FixedSystemAdapter do
  @moduledoc """
    Adapter for providing system properties, like system dates etc.
  """
  alias Propy.Statistics.Core.IAdaptSystem

  @behaviour IAdaptSystem

  # ~D[2021-12-03]
  @impl IAdaptSystem
  def utc_now_as_date() do
    {:ok, now} = Date.from_iso8601("2021-01-17")
    now
  end

  # ~D[2021-11-26]
  @impl IAdaptSystem
  def previous_week() do
    Date.add(utc_now_as_date(), -7)
  end
end