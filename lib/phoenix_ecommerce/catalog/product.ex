defmodule PhoenixEcommerce.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixEcommerce.Catalog.Category

  schema "products" do
    field :description, :string
    field :price, :decimal
    field :title, :string
    field :views, :integer

    many_to_many :categories, Category, join_through: "product_categories", on_replace: :delete
    # 'on_replace: :delete' declares existing join records are deleted upon category change

    timestamps()
  end

  @doc false
  # Doc false means that this function is not meant to be part of the public context API (Catalog)
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price, :views])
    |> validate_required([:title, :description, :price, :views])
  end
end
