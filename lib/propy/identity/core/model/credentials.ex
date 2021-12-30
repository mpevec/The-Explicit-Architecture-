defmodule Propy.Identity.Core.Model.Credentials do
  @moduledoc """
    Value Object
  """
  alias Data.Parser.BuiltIn

  defstruct [:username, :password]

  @opaque t :: %__MODULE__{
    username: String.t(),
    password: String.t()
  }

  @spec new(map()) :: {:ok, t()} | {:error, any()}
  def new(params) do
    Data.Constructor.struct([
      {:username, BuiltIn.string()},
      {:password, BuiltIn.string()}],
      __MODULE__,
      params
    )
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = token_expiration) do
    token_expiration
    |> Map.from_struct()
  end

  @spec username(t()) :: String.t()
  def username(%__MODULE__{username: u}), do: u

  @spec password(t()) :: String.t()
  def password(%__MODULE__{password: p}), do: p
end