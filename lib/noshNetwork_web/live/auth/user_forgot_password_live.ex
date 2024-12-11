defmodule NoshNetworkWeb.Auth.UserForgotPasswordLive do
  use NoshNetworkWeb, :live_view

  alias NoshNetwork.Data.Context.Users

  def render(assigns) do
    ~H"""
    <div class="m-auto max-w-screen-xl overflow-hidden  font-brand">
      <div class="flex lg:flex-row-reverse flex-col items-start">
        <div class="lg:w-1/2 w-full h-auto lg:flex hidden items-center justify-center flex-col">
          <img src="/images/auth_image.png" alt="registration page" class="rounded-b-md" />
        </div>

        <div class="w-full lg:w-1/2 flex flex-col p-6 gap-4 lg:mt-20 mt-0">
          <.header class="text-center text-[#0b4927]">
            Forgot your password?
            <:subtitle>We'll send a password reset link to your inbox</:subtitle>
          </.header>

          <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
            <.input field={@form[:email]} type="email" placeholder="Email" required />
            <:actions>
              <.button phx-disable-with="Sending..." class="w-full">
                Send password reset instructions
              </.button>
            </:actions>
          </.simple_form>
          <p class="text-center text-sm mt-4">
            <.link href={~p"/auth/signup"} class="hover:text-[#0b4927]">Register</.link>
            | <.link href={~p"/auth/log_in"} class="hover:text-[#0b4927]">Log in</.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Users.get_user_by_email(email) do
      Users.deliver_user_reset_password_instructions(
        user,
        &url(~p"/auth/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
