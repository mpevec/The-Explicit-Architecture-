defmodule Propy.Identity.Core.Model.RefreshToken do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias Propy.Identity.Core.Model.User

  defstruct [:user_id, :expire_in, :value]

  @opaque t :: %__MODULE__{
    user_id: User.id(),
    expire_in: DateTime.t(),
    value: String.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:user_id, BuiltIn.integer()},
      {:expire_in, BuiltIn.datetime()},
      {:value, BuiltIn.string()}],
      __MODULE__,
      params
    )
  end

  @spec upgrade(t(), DateTime.t(), String.t()) :: {:ok, t()}
  def upgrade(%__MODULE__{} = refresh_token, expire_in, value) do
    {:ok, %__MODULE__{refresh_token | expire_in: expire_in, value: value}}
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = refresh_token) do
    refresh_token
    |> Map.from_struct()
  end

  @spec user_id(t()) :: User.id()
  def user_id(%__MODULE__{user_id: uid}), do: uid

  @spec expire_in(t()) :: DateTime.t()
  def expire_in(%__MODULE__{expire_in: ei}), do: ei

  @spec value(t()) :: String.t()
  def value(%__MODULE__{value: v}), do: v
end
