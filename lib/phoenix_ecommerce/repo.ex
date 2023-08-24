defmodule PhoenixEcommerce.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_ecommerce,
    adapter: Ecto.Adapters.Postgres
end
