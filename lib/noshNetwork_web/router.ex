defmodule NoshNetworkWeb.Router do
  use NoshNetworkWeb, :router
  use Phoenix.Router, helpers: true

  import NoshNetworkWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug(NoshNetworkWeb.Plugs.UserAgentLogger)
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NoshNetworkWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NoshNetworkWeb do
    pipe_through :browser

    live "/", HomepageLive.Index

    live "/about", AboutLive.Index
    live "/contact", ContactLive.Index
  end

  # Other scopes may use custom stacks.
  # scope "/api", NoshNetworkWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:noshNetwork, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NoshNetworkWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/auth", NoshNetworkWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{NoshNetworkWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/signup", Signup.Index
      live "/log_in", Auth.UserLoginLive, :new
      live "/reset_password", Auth.UserForgotPasswordLive, :new
      live "/reset_password/:token", Auth.UserResetPasswordLive, :edit
    end

    post "/log_in", UserSessionController, :create
  end

  scope "/users", NoshNetworkWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{NoshNetworkWeb.UserAuth, :ensure_authenticated}] do
      live "/dashboard", DashboardLive.Index, :index
      live "/cater", CaterLive.Index
      live "/create_booking", BookingLive.Index
      live "/booking", ShowUserBookingLive.Index
      live "/welcome", WelcomeLive.Welcome
      live "/onboarding", OnboardingLive.Index
      live "/settings", Auth.UserSettingsLive, :edit
      live "/settings/confirm_email/:token", Auth.UserSettingsLive, :confirm_email
    end
  end

  scope "/", NoshNetworkWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{NoshNetworkWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", Auth.UserConfirmationLive, :edit
      live "/users/confirm", Auth.UserConfirmationInstructionsLive, :new
    end
  end
end
