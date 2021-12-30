defmodule Propy.Statistics.Core.Repository.Schema.PropertyAd do
  @moduledoc """
    property_ad schema
  """
  use Ecto.Schema

  alias Propy.Statistics.Core.Repository.Schema.ZipCode

  @primary_key {:id_property_ad, :id, autogenerate: true}
  schema "property_ad" do
    field :uid, :string
    field :title, :string
    field :href, :string
    field :description, :string
    field :price, :decimal
    field :price_before, :decimal
    field :size, :decimal
    field :agency, :string
    field :year_builded, :integer
    field :etage, :string
    field :last_date_checked, :date
    field :zip_code, :string, virtual: true
    timestamps()

    belongs_to :zipcode, ZipCode,
      references: :id_zip_code,
      foreign_key: :id_zip_code
  end
end
