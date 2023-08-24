# Delete all entries from all uuid/cart/order linked tables
# Used to allow for migration to integrating accounts with carts/orders
import Ecto.Query, warn: false
alias PhoenixEcommerce.Repo

Repo.delete_all(PhoenixEcommerce.ShoppingCart.Cart)
Repo.delete_all(PhoenixEcommerce.Orders.LineItem)
Repo.delete_all(PhoenixEcommerce.Orders.Order)
