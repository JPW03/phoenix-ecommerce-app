defmodule PhoenixEcommerceWeb.Router do
  use PhoenixEcommerceWeb, :router

  import PhoenixEcommerceWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixEcommerceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_cart
    # plug :log_session
    # plug :log_connection
  end

  # DEBUG
  # defp log_session(conn, _) do
  #   IO.inspect(get_session(conn))
  #   conn
  # end
  # defp log_connection(conn, _) do
  #   IO.inspect(conn)
  #   conn
  # end

  alias PhoenixEcommerce.ShoppingCart

  defp fetch_current_cart(conn, _) do
    if user = conn.assigns.current_user do
      if cart = ShoppingCart.get_cart_by_user(user) do
        assign(conn, :cart, cart)
      else
        {:ok, new_cart} = ShoppingCart.create_cart(user)
        assign(conn, :cart, new_cart)
      end
    else
      conn
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Home Page
  scope "/", PhoenixEcommerceWeb do
    pipe_through [:browser]

    get "/", PageController, :home
  end

  ## Catalog, Shopping Cart and Orders (Log in required)
  scope "/", PhoenixEcommerceWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/products", ProductController

    resources "/cart_items", CartItemController, only: [:create, :delete]

    get "/cart", CartController, :show
    put "/cart", CartController, :update

    resources "/orders", OrderController, only: [:create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixEcommerceWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_ecommerce, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixEcommerceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Signed-out Account Management
  scope "/", PhoenixEcommerceWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PhoenixEcommerceWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  ## Signed-in Account Management
  scope "/", PhoenixEcommerceWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PhoenixEcommerceWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", PhoenixEcommerceWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PhoenixEcommerceWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
