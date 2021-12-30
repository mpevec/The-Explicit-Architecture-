defmodule Identity.Rest.JwtAdapterTest do
  alias Propy.Identity.Core.IAdaptJwt

  @behaviour IAdaptJwt

  @moduledoc """
  .
  """

  @impl IAdaptJwt
  def create(_user_id, _user_signature, _due_time) do
    {:ok, "a.b.c"}
  end

  @impl IAdaptJwt
  def verify_signature(_token) do
    {:ok, %{sub: "test_id"}}
  end

  @impl IAdaptJwt
  def verify_claims(%JOSE.JWT{fields: _fields} = _claims, _utc_now) do
    {:ok, "test_id"}
  end
end