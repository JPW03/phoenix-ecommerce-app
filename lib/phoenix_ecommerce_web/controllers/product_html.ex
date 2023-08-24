defmodule PhoenixEcommerceWeb.ProductHTML do
  use PhoenixEcommerceWeb, :html

  def category_opts(changeset) do
    existing_ids = changeset
    |> Ecto.Changeset.get_change(:categories, [])
    |> Enum.map(& &1.data.id)

    for cat <- PhoenixEcommerce.Catalog.list_categories() do
      [key: cat.title, value: cat.id, selected: cat.id in existing_ids]
    end
  end

  embed_templates "product_html/*"

  @doc """
  Renders a product form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def product_form(assigns)
end
