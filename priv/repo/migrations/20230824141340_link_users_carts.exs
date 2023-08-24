defmodule PhoenixEcommerce.Repo.Migrations.LinkUsersCarts do
  use Ecto.Migration

  def change do

    alter table(:carts) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      remove :user_uuid
    end

    alter table(:orders) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      remove :user_uuid
    end

    create unique_index(:carts, [:user_id])
  end
end
