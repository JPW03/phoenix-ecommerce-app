defmodule PhoenixEcommerce.Repo.Migrations.CreateProductCategories do
  use Ecto.Migration

  # The skeleton of this file was generated using 'mix ecto.gen.migration'

  def change do
    create table(:product_categories, primary_key: false) do
      # Make sure to link the foriegn keys to their original table
      #  and what happens to them when their original is deleted.
      add :product_id, references(:products, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
    end

    # Define how the table should be indexed
    create index(:product_categories, [:product_id])
    create unique_index(:product_categories, [:category_id, :product_id])
    # Adding a separate index for the category_id field is redundant,
    #  because :category_id is the leftmost prefix of the composite key
    #  i.e. the composite key is sorted indexed by category first, product second
  end
end
