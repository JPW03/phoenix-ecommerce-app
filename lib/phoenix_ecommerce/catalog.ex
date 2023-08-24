defmodule PhoenixEcommerce.Catalog do
  @moduledoc """
  The Catalog context.
  A "context" is just a high-level way of thinking about a subection of
  the application. They are meant to encapsulate certain functionalities,
  so higher levels of the application are more abstracted.
  """

  # This context was generated using 'mix phx.gen.html'
  # Categories were added separately to this context using 'mix phx.gen.context'
  #  (They are similar generators except .context doesn't generate web pages)

  # Note that --no-context and --no-schema flags can be used in the phx.gen.html command
  #  to include/exclude content

  # Other generators not used here:
  #  - phx.gen.json - same as HTML but for a JSON resource
  #  - phx.gen.schema - same as context but only the schema and no context
  #  - phx.gen.auth - same as HTML but with extra authenticaion specific features.
  #     Can automatically generate an account system with proper authentication
  #  - phx.gen.channel - creates a channel, and asks if you want to create a socket for it
  #  - phx.gen.socket - for creating a socket for a channel
  #  - phx.gen.presence - creates a presence tracker
  #  - ecto.gen.repo - for creating a new data store (a project can have multiple data stores)
  #  - ecto.gen.migration - generates an empty migration file with a given snake case name

  import Ecto.Query, warn: false
  alias PhoenixEcommerce.Repo

  alias PhoenixEcommerce.Catalog.{Product, Category}

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:categories)
    # .preload allows the reference of 'product.categories' in controllers, etc
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> change_product(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> change_product(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    categories = list_categories_by_id(attrs["category_ids"])

    product
    |> Repo.preload(:categories)
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:categories, categories)
  end

  def increment_page_views(%Product{} = product) do
    {1, [%Product{views: views}]} =
      from(p in Product, where: p.id == ^product.id, select: [:views])
      |> Repo.update_all(inc: [views: 1])
      # update_all/3 is used instead of update/3 because it allows for batch DB updates
      #  (i.e. multiple users won't conflict)

    put_in(product.views, views)
  end

  alias PhoenixEcommerce.Catalog.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Returns a list of categories given a list of IDs.
  """
  def list_categories_by_id(nil), do: []
  def list_categories_by_id(category_ids) do
    Repo.all(from c in Category, where: c.id in ^category_ids)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Returns a string in price format.
  """
  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end
