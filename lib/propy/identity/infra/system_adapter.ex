defmodule Propy.Identity.Infra.SystemAdapter do
  @moduledoc """
    Adapter for providing system properties, like system dates etc.
  """
  alias Propy.Identity.Core.IAdaptSystem

  @behaviour IAdaptSystem

  # ~U[2021-12-03 13:46:34.711523Z]
  @impl IAdaptSystem
  def utc_now() do
    DateTime.utc_now()
  end

  @impl IAdaptSystem
  def uuid() do
    Ecto.UUID.generate()
  end
end