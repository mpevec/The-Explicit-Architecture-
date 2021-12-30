defmodule Propy.Statistics.Core.IAdaptSystem do
  use Knigge,
    otp_app: :propy

  @moduledoc """
    Providing system properties
  """
  #@callback utc_now() :: DateTime.t()
  @callback utc_now_as_date() :: Date.t()
  @callback previous_week() :: Date.t()
  #@callback uuid() :: String.t()
end