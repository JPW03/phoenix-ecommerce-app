defmodule PhoenixEcommerce.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :price_when_carted, :decimal
    field :quantity, :integer

    # 'belongs_to' defines a field :cart_id/:product_id and
    #   references that to the ID of the given schema
    belongs_to :cart, PhoenixEcommerce.ShoppingCart.Cart
    belongs_to :product, PhoenixEcommerce.Catalog.Product

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:price_when_carted, :quantity])
    |> validate_required([:price_when_carted, :quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0, less_than: 100)
  end
end