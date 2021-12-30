defmodule Identity.Rest.RepositoryAdapterTest do
  @moduledoc """
  .
  """
  alias Propy.Identity.Core.Service.IManageRepository
  alias Propy.Identity.Core.Model.{RefreshToken, User}

  @behaviour IManageRepository

  @impl IManageRepository
  def fetch_user(_credentials) do
    {:ok, to_user()}
  end

  @impl IManageRepository
  def fetch_user_by_refresh_token(_refresh_token) do
    {:ok, to_user()}
  end

  @impl IManageRepository
  def persist_refresh_token(_refresh_token) do
    {:ok, true}
  end

  @impl IManageRepository
  def fetch_refresh_token(_utc_now, _refresh_token_value) do
    RefreshToken.new(%{user_id: 123, expire_in: DateTime.utc_now(), value: "uuid"})
  end

  defp to_user() do
    {:ok, user} = User.new(%{id: 123, first_name: "first_name", last_name: "last_name", username: "username" })
    user
  end
end