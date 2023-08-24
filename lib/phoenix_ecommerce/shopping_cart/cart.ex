defmodule PhoenixEcommerce.ShoppingCart.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    belongs_to :user, PhoenixEcommerce.Accounts.User

    has_many :items, PhoenixEcommerce.ShoppingCart.CartItem

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
