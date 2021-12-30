defmodule Propy.Identity.Core.IAdaptJwt do
  use Knigge,
    otp_app: :propy

  @moduledoc false

  @callback create(integer(), String.t(), DateTime.t()) :: {:ok, String.t()}
  @callback verify_signature(String.t()) :: {:ok, map()} | {:error, String.t()}
  @callback verify_claims(map(), DateTime.t()) :: {:ok, String.t()} | {:error, String.t()}
end