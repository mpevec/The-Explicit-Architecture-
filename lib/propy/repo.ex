defmodule Propy.Repo do
  @moduledoc false
  require Logger

  use Ecto.Repo,
    otp_app: :propy,
    adapter: Ecto.Adapters.Postgres

  @spec fetch_one(Ecto.Queryable.t()) :: {:ok, any} | {:error, atom()}
  def fetch_one(query) do
    case one(query) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @spec fetch(Ecto.Queryable.t(), term()) :: {:ok, any} | {:error, atom()}
  def fetch(query, id) do
    case get(query, id) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @spec fetch_by(Ecto.Queryable.t(), Keyword.t() | map()) :: {:ok, any} | {:error, atom()}
  def fetch_by(query, clauses) do
    case get_by(query, clauses) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @spec transact((... -> any()), Keyword.t()) :: {:ok, any} | {:error, any()}
  def transact(fnct, opts \\ []) do
    transaction(
      fn ->
        case fnct.() do
          {:ok, result} -> result
          # Only changeset errors are here, DB errors are thrown
          {:error, reason} ->
            Logger.error("Error with Repo request #{inspect(reason)}")
            rollback(reason) # returns {:error, reason}
        end
      end,
      opts
    )
  end
end