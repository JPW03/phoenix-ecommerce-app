defmodule PhoenixEcommerceWeb.OrderController do
  use PhoenixEcommerceWeb, :controller

  alias PhoenixEcommerce.Orders

  def create(conn, _) do
    case Orders.complete_order(conn.assigns.cart) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order placed successfully.")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "There was an error processing your order")
        |> redirect(to: ~p"/cart")
    end
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(conn.assigns.current_user, id)
    # 'get_order!' validates that the cart id must belong to the current user
    render(conn, :show, order: order)
  end

end
