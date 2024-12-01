defmodule NoshNetworkWeb.Auth.UserResetPasswordLive do
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
          <.header  class="text-center text-[#0b4927]">Reset Password</.header>

          <.simple_form
            for={@form}
            id="reset_password_form"
            phx-submit="reset_password"
            phx-change="validate"
          >
            <.error :if={@form.errors != []}>
              Oops, something went wrong! Please check the errors below.
            </.error>

            <.input field={@form[:password]} type="password" label="New password" required />
            <.input
              field={@form[:password_confirmation]}
              type="password"
              label="Confirm new password"
              required
            />
            <:actions>
              <.button phx-disable-with="Resetting..." class="w-full">Reset Password</.button>
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

  def mount(params, _session, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket, label: "socket oooo")
    socket = assign_user_and_token(socket, params)
    IO.inspect(socket, label: "socket not found")
    form_source =
      case socket.assigns do
        %{user: user} ->
          Users.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Users.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/auth/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    IO.inspect(token, label: "token available")
    if user = Users.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
