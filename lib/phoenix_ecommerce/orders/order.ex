defmodule PhoenixEcommerce.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :total_price, :decimal

    belongs_to :user, PhoenixEcommerce.Accounts.User

    has_many :line_items, PhoenixEcommerce.Orders.LineItem
    has_many :products, through: [:line_items, :product]
    # 'through:' allows associations to be defined in terms of other associations

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_price])
    |> validate_required([:total_price])
  end
end
