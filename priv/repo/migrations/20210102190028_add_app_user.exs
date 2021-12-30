defmodule PropyCore.Repo.Migrations.AddAppUser do
  use Ecto.Migration

  def up do
    create table("app_user", primary_key: false) do
      add :id_app_user, :serial, primary_key: true
      add :first_name, :text, null: false
      add :last_name, :text, null: false
      add :username, :text, null: false
      add :passhash, :text, null: false
      timestamps()
    end

    flush()
    
    execute """
      INSERT INTO app_user(first_name, last_name, username, passhash, inserted_at, updated_at) VALUES ('Janez', 'Novak', 'janez.novak@hey.com', md5('abc123'), NOW(), NOW());
    """
  end

  def down do
    drop table("app_user")
  end

end
