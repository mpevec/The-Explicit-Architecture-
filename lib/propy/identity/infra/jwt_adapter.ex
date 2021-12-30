defmodule Propy.Identity.Infra.JwtAdapter do
  alias Propy.Identity.Core.IAdaptJwt

  @behaviour IAdaptJwt

  @moduledoc """
  .
  """

  @impl IAdaptJwt
  def create(user_id, user_signature, due_time) do
    issuer = Application.fetch_env!(:propy, :jwt_issuer)
    encoded_secret = Application.fetch_env!(:propy, :jwt_secret_hs256_signature) |> encode_secret

    # JSON Web Keys
    jwk = %{
      "kty" => "oct",
      "k" => encoded_secret
    }

    # JSON Web Signature (JWS)
    jws = %{
      "alg" => "HS256"
    }

    # JSON Web Token (JWT)
    jwt = %{
      "iss" => issuer,
      "sub" => user_id,
      "exp" => due_time,
      "name" => user_signature,
    }

    {_, token} = JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact()
    {:ok, token}
  end

  @impl IAdaptJwt
  def verify_signature(token) do
    encoded_secret = Application.fetch_env!(:propy, :jwt_secret_hs256_signature) |> encode_secret

    jwk = %{
      "kty" => "oct",
      "k" => encoded_secret
    }

    case JOSE.JWT.verify(jwk, token) do
      {true, claims, _} -> {:ok, claims}
      _ -> {:error, "Token signature verification failed!"}
    end
  end

  @impl IAdaptJwt
  def verify_claims(%JOSE.JWT{fields: fields} = claims, utc_now) do
    with %{"exp" => exp} <- fields,
        {:ok, expiration_as_datetime, _} <- DateTime.from_iso8601(exp),
        :gt <- DateTime.compare(expiration_as_datetime, utc_now),
        sub <- get_claim(claims, "sub")
    do
      {:ok, sub}
    else
      _ -> {:error, "Expired token or no sub claim found"}
    end
  end

  defp get_claim(%JOSE.JWT{fields: fields} = _jwt_claims, key) do
    %{^key => value} = fields
    value
  end

  defp encode_secret(secret), do: secret |> :jose_base64url.encode()
end