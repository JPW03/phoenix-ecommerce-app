defmodule PhoenixEcommerceWeb.CartHTML do
  use PhoenixEcommerceWeb, :html

  import PhoenixEcommerce.Catalog, only: [currency_to_str: 1]
  alias PhoenixEcommerce.ShoppingCart

  embed_templates "cart_html/*"
end
