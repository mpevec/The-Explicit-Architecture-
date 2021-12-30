defmodule PropyCore.Repo.Migrations.AddZipCode do
  use Ecto.Migration

  def up do
    create table("zip_code", primary_key: false) do
      add :id_zip_code, :serial, primary_key: true
      add :code, :text, null: false
      add :name, :text, null: false
      timestamps()
    end

    flush()
    
    execute """
      INSERT INTO zip_code(code, name, inserted_at, updated_at) VALUES ('2000', 'Maribor', now(), now());
    """
    execute """
      INSERT INTO zip_code(code, name, inserted_at, updated_at) VALUES ('1000', 'Ljubljana', now(), now());
    """
  end

  def down do
    drop table("zip_code")
  end
end

