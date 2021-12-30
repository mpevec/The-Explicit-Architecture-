defmodule Propy.Identity.Core.Repository.Schema.AppUserLogin do
  @moduledoc """
    app_user_login schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Propy.Identity.Core.Repository.Schema.AppUser

  @type t :: %__MODULE__{}

  @fields ~w(id_app_user time_expired uuid)a

  @primary_key {:id_app_user_login, :id, autogenerate: true}
  schema "app_user_login" do
    field :time_expired, :utc_datetime
    field :uuid, :string
    timestamps()

    # To pomeni AppUser ima asociacijo 'belongs_to' z mano.
    # Sicer preko njegovega primarnega kljuca (references)
    # in mojega foreign_keya
    # Pravilo, tisti ki ima foreight key ima belongs_to asociacijo
    belongs_to :appuser, AppUser,
      references: :id_app_user,
      foreign_key: :id_app_user
  end

  def create_changeset(%__MODULE__{} = app_user_login, params) do
    app_user_login
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:id_app_user)
    |> unique_constraint(:uuid)
  end
end
