defmodule Propy.Identity.Core.Service.IManageRepository do
  use Knigge,
    otp_app: :propy

  alias Propy.Identity.Core.Model.{Credentials, RefreshToken, User}

  @moduledoc false

  @callback fetch_user(Credentials.t()) :: {:ok, User.t()} | {:error, any()}
  @callback fetch_user_by_refresh_token(RefreshToken.t()) :: {:ok, User.t()} | {:error, any()}
  @callback persist_refresh_token(RefreshToken.t()) :: {:ok, any()} | {:error, any()}
  @callback fetch_refresh_token(DateTime.t(), String.t()) :: {:ok, RefreshToken.t()} | {:error, any()}
end