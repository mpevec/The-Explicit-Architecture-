defmodule Propy.Identity.Core.Repository.Identity do
  @moduledoc """
  .
  """
  import Ecto.Query
  alias Propy.Identity.Core.Service.IManageRepository
  alias Propy.Identity.Core.Model.{Credentials, NotExpiredPeriod, RefreshToken, User}
  alias Propy.Identity.Core.Repository.Schema.{AppUser, AppUserLogin}
  alias Propy.Repo

  @behaviour IManageRepository

  @impl IManageRepository
  def fetch_user(credentials) do
    query = from u in AppUser,
      where: fragment("md5(?)", ^Credentials.password(credentials)) == u.passhash
        and u.username == ^Credentials.username(credentials)

    case Repo.fetch_one(query) do
      {:ok, res} -> to_user(res)
      err -> err
    end
  end

  @impl IManageRepository
  def fetch_user_by_refresh_token(refresh_token) do
    case Repo.fetch(AppUser, RefreshToken.user_id(refresh_token)) do
      {:ok, res} -> to_user(res)
      err -> err
    end
  end

  @impl IManageRepository
  def persist_refresh_token(refresh_token) do
    params = %{
      id_app_user: RefreshToken.user_id(refresh_token),
      time_expired: RefreshToken.expire_in(refresh_token),
      uuid: RefreshToken.value(refresh_token)
    }

    changeset = AppUserLogin.create_changeset(%AppUserLogin{}, params)
    Repo.transact(fn -> Repo.insert(changeset) end)
  end

  @impl IManageRepository
  def fetch_refresh_token(utc_now, refresh_token_value) do
    with {:ok, user_login} <- Repo.fetch_by(AppUserLogin, uuid: refresh_token_value),
      {:ok, not_expired_period} <- NotExpiredPeriod.new(%{utc_now: utc_now, expire_in: user_login.time_expired})
    do
      RefreshToken.new(%{user_id: user_login.id_app_user, expire_in: NotExpiredPeriod.expire_in(not_expired_period), value: user_login.uuid})
    else
      err -> err
    end
  end

  defp to_user(%AppUser{id_app_user: id, first_name: first_name, last_name: last_name, username: username}) do
    User.new(%{id: id, first_name: first_name, last_name: last_name, username: username })
  end
end