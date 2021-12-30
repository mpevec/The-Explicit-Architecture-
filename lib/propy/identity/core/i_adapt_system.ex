defmodule Propy.Identity.Core.IAdaptSystem do
  use Knigge,
    otp_app: :propy

  @moduledoc """
    Providing system properties
  """
  @callback utc_now() :: DateTime.t()
  @callback uuid() :: String.t()
end