defmodule PicChatWeb.MessageLive.Index do
  use PicChatWeb, :live_view

  alias PicChat.Chat
  alias PicChat.Chat.Message

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect("Message.Live MOUNT")
    IO.inspect(self())
    {:ok, assign(socket, :messages, Chat.list_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(socket.assigns.live_action, label: "Message.Live HANDLE PARAMS")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Chat.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Chat.get_message!(id)
    {:ok, _} = Chat.delete_message(message)

    {:noreply, assign(socket, :messages, Chat.list_messages())}
  end
end
