defmodule NoshNetworkWeb.Auth.UserLoginLive do
  use NoshNetworkWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm p-6 font-brand">
      <div class="mx-auto flex itmes-center justify-center">
        <a href={~p"/"}>
          <img src="/images/transparent_logo.png" alt="img" class="w-[150px]" />
        </a>
      </div>
      <.header class="text-center text-black lg:text-3xl text-2xl">
        Sign in to account
        <:subtitle>
          Don't have an account?
          <.link
            navigate={~p"/auth/register"}
            class="font-semibold text-brand text-white hover:underline"
          >
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="login_form"
        action={~p"/auth/log_in"}
        class="bg-white bg-opacity-50 p-6 rounded-md shadow-sm shadow-gray-200 my-4"
      >
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
        </:actions>

        <:actions>
          <.link href={~p"/auth/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full my-3">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
