defmodule PicChatWeb.MessageLive.FormComponent do
  use PicChatWeb, :live_component

  alias PicChat.Chat

  @impl true

  # Mounts
  # Updates
  # Renders

  def mount(socket) do
    {:ok, allow_upload(socket, :media, accept: [".jpg", ".png", ".jpeg"], max_entries: 1)}
  end

  def update(%{message: message} = assigns, socket) do
    changeset = Chat.change_message(message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      socket.assigns.message
      |> Chat.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    uploads =
      consume_uploaded_entries(socket, :media, fn %{path: path}, _entry ->
        file_name = Path.split(path) |> Enum.at(-1)
        destination = Path.join("priv/static/images/", file_name)

        File.cp(path, destination)

        {:ok, "/images/#{file_name}"}
      end)

    save_message(
      socket,
      socket.assigns.action,
      Map.put(message_params, "media", List.first(uploads))
    )
  end

  defp save_message(socket, :edit, message_params) do
    case Chat.update_message(socket.assigns.message, message_params) do
      {:ok, message} ->
        PicChatWeb.Endpoint.broadcast_from(self(), "chat_messages", "edit_message", message)

        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_message(socket, :new, message_params) do
    case Chat.create_message(message_params) do
      {:ok, message} ->
        # broadcast
        PicChatWeb.Endpoint.broadcast("chat_messages", "create_message", message)

        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
