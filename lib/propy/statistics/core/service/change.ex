defmodule Propy.Statistics.Core.Service.Change do
  @moduledoc """
  .
  """
  @spec change_as_percentage(Decimal.t(), Decimal.t()) :: {:ok, Decimal.t()}
  def change_as_percentage(previous_value, value) do
    if (Decimal.eq?(previous_value, 0) or Decimal.eq?(value, 0)) do {:ok, 0}
    else
      # 100*((value - previous_value)/previous_value)
      sub = Decimal.sub(value, previous_value)
      div = Decimal.div(sub, previous_value)
      {:ok, Decimal.mult(100, div)}
    end
  end
end