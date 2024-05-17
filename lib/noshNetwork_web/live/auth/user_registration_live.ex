defmodule NoshNetworkWeb.Auth.UserRegistrationLive do
  use NoshNetworkWeb, :live_view

  alias NoshNetwork.Data.Context.Users
  alias NoshNetwork.Data.Schema.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm p-6 font-brand">
      <div class="mx-auto flex itmes-center justify-center">
        <a href={~p"/"}>
          <img src="/images/transparent_logo.png" alt="img" class="w-[150px]" />
        </a>
      </div>
      <.header class="text-center text-black lg:text-3xl text-2xl">
        Register for an account
        <:subtitle>
          Already registered?
          <.link
            navigate={~p"/auth/log_in"}
            class="text-lg font-semibold text-brand hover:underline "
          >
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/auth/log_in?_action=registered"}
        method="post"
        class="bg-white bg-opacity-50 p-6 rounded-md shadow-sm shadow-gray-200 my-4"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>
        <.input field={@form[:name]} type="text" label="Name" required />
        <.input field={@form[:username]} type="text" label="Username" required />
        <.input field={@form[:email]} type="email" label="Email" required />

        <.input field={@form[:password]} type="password" label="Password" required />

        <.input field={@form[:role]} type="hidden" required value="user" />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full my-3">
            Create an account
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Users.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Users.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
