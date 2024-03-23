defmodule NoshNetworkWeb.OnboardingLive.Index do
  use NoshNetworkWeb, :live_view
  alias NoshNetwork.Data.Context.Users
  alias NoshNetwork.Data.Context.Caters
  alias NoshNetwork.Data.Schema.Cater
  # alias NoshNetwork.Data.Schema.User
  import Phoenix.HTML.Form

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    # new_cater = %Cater{}
    # cater_changeset = Cater.cater_changeset(new_cater)

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
      |> assign(:cater_form, to_form(Caters.change_cater(%Cater{})))
      |> allow_upload(:profile_picture, accept: ~w(.png .jpg), max_entries: 1)
      |> assign(:valid, false)
      |> assign(:user_id, nil)

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

    {:noreply, socket |> assign(:valid, changeset.valid?) |> assign_form(changeset)}
  end

  def handle_event("update-user", %{"user" => user_params}, socket) do
    updated_user_params =
      user_params
      |> Map.put("profile_picture", List.first(consume_files(socket)))

    if socket.assigns.valid do
      case apply(
             Users,
             :update_user_profile,
             [
               socket.assigns.current_user,
               updated_user_params
             ]
           ) do
        {:ok, user} when user.role == "user" ->
          socket =
            socket
            |> put_flash(:info, "User updated successfully")
            |> push_navigate(to: ~p"/users/dashboard")

          {:noreply, socket}

        {:ok, _user} ->
          {:noreply, socket |> put_flash(:info, "Contact Info is succesfully")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign_form(socket, changeset)}
      end
    else
      {:noreply, socket}
    end
  end

  # caters validation and creation
  @impl true
  def handle_event("validate-cater", %{"cater" => cater_params}, socket) do
    cater_params = cater_params |> Map.put("user_id", socket.assigns.current_user.id)

    changeset =
      %Cater{}
      |> Caters.change_cater(cater_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :cater_form, to_form(changeset))}
  end

  @impl true
  def handle_event("update-cater", %{"cater" => cater_params}, socket) do
    cater_params = cater_params |> Map.put("user_id", socket.assigns.current_user.id)
    IO.inspect(cater_params, label: 'hello')

    case Caters.create_cater(cater_params) do
      {:ok, _cater} ->
        changeset = Caters.change_cater(%Cater{})

        socket =
          socket
          |> put_flash(:info, "cater onboarded successfully")
          |> push_navigate(to: ~p"/users/dashboard")
          |> assign(:cater_form, to_form(changeset))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :cater_form, to_form(changeset))}
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

  defp button_valid(true), do: "bg-emOrange-dark"
  defp button_valid(false), do: "bg-zinc-600"
end
