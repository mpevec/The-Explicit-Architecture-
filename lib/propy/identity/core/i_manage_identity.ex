defmodule Propy.Identity.Core.IManageIdentity do
  use Knigge,
    otp_app: :propy

  @moduledoc false

  @callback login(map()) :: {:ok, map()} | {:error, any()}
  @callback silent_login(String.t()) :: {:ok, map()} | {:error, any()}
  @callback authenticate(String.t()) :: {:ok, String.t()} | {:error, any()}
end
