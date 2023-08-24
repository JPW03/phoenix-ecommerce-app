defmodule PhoenixEcommerceWeb.CartHTML do
  use PhoenixEcommerceWeb, :html

  alias PhoenixEcommerce.ShoppingCart

  embed_templates "cart_html/*"

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end
