defmodule PropyCore.Repo.Migrations.AddAppUserLogin do
  use Ecto.Migration

  def change do
    create table("app_user_login", primary_key: false) do
      add :id_app_user_login, :serial, primary_key: true
      add :id_app_user, references("app_user", column: :id_app_user), null: false
      add :uuid, :string, null: false
      add :time_expired, :utc_datetime, null: false
      timestamps()
    end

    create unique_index("app_user_login", :uuid)
  end
end
