defmodule PicChatWeb.MessageLive.Index do
  use PicChatWeb, :live_view

  alias PicChat.Chat
  alias PicChat.Chat.Message

  @impl true
  def mount(_params, _session, socket) do
    PicChatWeb.Endpoint.subscribe("chat_messages")

    {:ok,
     socket
     |> assign(:messages, Chat.list_messages(limit: 10))
     |> assign(:page, 1)}
  end

  @impl true
  def handle_info(%{event: "create_message", payload: message}, socket) do
    {:noreply, assign(socket, :messages, [message | socket.assigns.messages])}
  end

  @impl true
  def handle_info(%{event: "delete_message"} = data, socket) do
    message_id = data.payload.message_id

    filtered_messages = Enum.reject(socket.assigns.messages, fn each -> each.id == message_id end)

    {:noreply, assign(socket, :messages, filtered_messages)}
  end

  @impl true
  def handle_info(%{event: "edit_message", payload: updated_message}, socket) do
    updated_messages =
      Enum.map(socket.assigns.messages, fn each ->
        if each.id == updated_message.id do
          updated_message
        else
          each
        end
      end)

    {:noreply, assign(socket, :messages, updated_messages)}
  end

  @impl true
  def handle_params(params, _url, socket) do
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

  def handle_event("get-more", _params, socket) do
    offset = socket.assigns.page * 10
    current_messages = socket.assigns.messages
    next_messages = Chat.list_messages(limit: 10, offset: offset)

    {:noreply,
     socket
     |> assign(:messages, current_messages ++ next_messages)
     |> assign(:page, socket.assigns.page + 1)
     |> assign(:loading, false)}
  end

  def handle_event("ping", _params, socket) do
    {:noreply, push_event(socket, "pong", %{})}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Chat.get_message!(id)
    {:ok, _} = Chat.delete_message(message)

    PicChatWeb.Endpoint.broadcast_from(self(), "chat_messages", "delete_message", %{
      message_id: message.id
    })

    filtered_messages = Enum.reject(socket.assigns.messages, fn each -> each.id == message.id end)

    {:noreply, assign(socket, :messages, filtered_messages)}
  end
end
