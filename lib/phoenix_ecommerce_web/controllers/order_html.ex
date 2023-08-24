defmodule PhoenixEcommerceWeb.OrderHTML do
  use PhoenixEcommerceWeb, :html

  import PhoenixEcommerce.Catalog, only: [currency_to_str: 1]

  embed_templates "order_html/*"
end
