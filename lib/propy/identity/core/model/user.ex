defmodule Propy.Identity.Core.Model.User do
  @moduledoc """
  .
  """
  alias Data.Parser.BuiltIn
  alias FE.Result

  defstruct [:id, :first_name, :last_name, :username, :signature]

  @type id :: integer()

  @opaque t :: %__MODULE__{
    id: id,
    first_name: String.t(),
    last_name: String.t(),
    username: String.t(),
    signature: String.t(),
  }

  @spec new(map()) :: {:ok, t()} | {:error, atom()}
  def new(params) do
    Data.Constructor.struct([
      {:id, BuiltIn.integer()},
      {:first_name, BuiltIn.string()},
      {:last_name, BuiltIn.string()},
      {:username, BuiltIn.string()}],
      __MODULE__,
      params
    ) |> signaturize
  end

  @spec to_map(t()) :: map()
  def to_map(%__MODULE__{} = user) do
    user
    |> Map.from_struct()
  end

  @spec id(t()) :: id
  def id(%__MODULE__{id: id}), do: id

  @spec signature(t()) :: String.t()
  def signature(%__MODULE__{signature: s}), do: s

  defp signaturize({:ok, %__MODULE__{} = user}) do
    {:ok, %__MODULE__{user | signature: "#{user.first_name} #{user.last_name}"}}
  end
  defp signaturize({:error, _} = err), do: err
  def is_type(%__MODULE__{} = input), do: Result.ok(input)
  def is_type(input), do: Result.error("not a type #{__MODULE__}: #{input}")
end