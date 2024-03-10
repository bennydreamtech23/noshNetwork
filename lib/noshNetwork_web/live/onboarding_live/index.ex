defmodule NoshNetworkWeb.OnboardingLive.Index do
  use NoshNetworkWeb, :live_view
  alias alias NoshNetwork.Data.Context.Users
  alias NoshNetwork.Data.Schema.User

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    changeset =
      apply(
        Users,
        :change_user_profile,
        [
          current_user
        ]
      )

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(check_errors: false)
      |> assign_form(changeset)
      |> allow_upload(:profile_picture, accept: ~w(.png .jpg), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user" => user}, socket) do
    changeset =
      apply(
        Users,
        :change_user_profile,
        [
          socket.assigns.current_user,
          user
        ]
      )
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign_form(changeset)}
  end

  def handle_event("update-user", %{"user" => user_params}, socket) do
    updated_user_params =
      user_params
      |> Map.put("profile_picture", List.first(consume_files(socket)))

    case apply(
           Users,
           :update_user_profile,
           [
             socket.assigns.current_user,
             updated_user_params
           ]
         ) do
      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:info, "User updated successfully")
          |> push_navigate(to: ~p"/users/dashboard")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:noshNetwork), "static", "uploads", Path.basename(path)])

      File.cp!(path, dest)
      {:postpone, ~p"/uploads/#{Path.basename(dest)}"}
    end)
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
