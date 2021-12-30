defmodule Propy.Identity.Core.Service.Identity do
  @moduledoc """
  .
  """
  alias Propy.Identity.Core.{IAdaptJwt, IAdaptSystem, IManageIdentity}
  alias Propy.Identity.Core.Service.IManageRepository
  alias Propy.Identity.Core.Model.{Credentials, ExpiryDate, NotExpiredPeriod, RefreshToken, User}

  @behaviour IManageIdentity

  @impl IManageIdentity
  def login(params) do
    with {:ok, credentials} <- Credentials.new(params),
         {:ok, user} <- IManageRepository.fetch_user(credentials),
         {:ok, expire_in} <- expire_in(),
         {:ok, token} <- IAdaptJwt.create(User.id(user), User.signature(user), expire_in),
         {:ok, refresh_token} <- RefreshToken.new(%{user_id: User.id(user), expire_in: expire_in, value: uuid()}),
         {:ok, _} <- IManageRepository.persist_refresh_token(refresh_token)
    do
        {:ok, %{token: token, refresh_token: RefreshToken.value(refresh_token)}}
    else
        err -> err
    end
  end

  @impl IManageIdentity
  def silent_login(refresh_token_value) do
    with {:ok, refresh_token} <- IManageRepository.fetch_refresh_token(utc_now(), refresh_token_value),
      {:ok, user} <- IManageRepository.fetch_user_by_refresh_token(refresh_token),
      {:ok, expire_in} <- expire_in(),
      {:ok, token} <- IAdaptJwt.create(User.id(user), User.signature(user), expire_in),
      {:ok, upgraded_refresh_token} <- RefreshToken.upgrade(refresh_token, expire_in, uuid()),
      {:ok, _} <- IManageRepository.persist_refresh_token(upgraded_refresh_token)
    do
      {:ok, %{token: token, refresh_token: RefreshToken.value(refresh_token)}}
    else
      err -> err
    end
  end

  @impl IManageIdentity
  def authenticate(token) do
    with {:ok, claims} <- IAdaptJwt.verify_signature(token),
        {:ok, user_id} <- IAdaptJwt.verify_claims(claims, utc_now())
    do
      {:ok, user_id}
    else
      err -> err
    end
  end

  defp uuid, do: IAdaptSystem.uuid()
  defp utc_now, do: IAdaptSystem.utc_now()
  defp expire_in do
    with {:ok, expiry_date} <- ExpiryDate.new(%{utc_now: utc_now(), expiry_in_minutes: 30}),
      {:ok, not_expired_period} <- NotExpiredPeriod.new(%{utc_now: utc_now(), expire_in: ExpiryDate.value(expiry_date)})
    do
      {:ok, NotExpiredPeriod.expire_in(not_expired_period)}
    else
      err -> err
    end
  end
end
