defmodule Propy.Identity.Core.Repository.Schema.AppUser do
  @moduledoc """
    app_user schema
  """
  use Ecto.Schema
  alias Propy.Identity.Core.Repository.Schema.AppUserLogin

  @type t :: %__MODULE__{}

  @primary_key {:id_app_user, :id, autogenerate: true}
  schema "app_user" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :passhash, :string

    timestamps()

    # AppUserLogin ima one-to-one "z mano", sicer preko mojega (references) 'id_app_user'
    # in njegovega foreign_key.a 'id_app_user'
    has_one :login, AppUserLogin,
      references: :id_app_user,
      foreign_key: :id_app_user

  end
end
