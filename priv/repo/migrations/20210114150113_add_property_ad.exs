defmodule PropyCore.Repo.Migrations.AddPropertyAd do
  use Ecto.Migration

  def change do
    create table("property_ad", primary_key: false) do
      add :id_property_ad, :serial, primary_key: true
      add :id_zip_code, references("zip_code", column: :id_zip_code), null: false
      add :uid, :text, null: false
      add :title, :text, null: false
      add :href, :text, null: false
      add :description, :text
      add :price, :decimal, null: false
      add :price_before, :decimal
      add :size, :decimal
      add :agency, :text
      add :year_builded, :integer, null: false
      add :etage, :text
      add :last_date_checked, :date, null: false
      timestamps()
    end
  end
end
