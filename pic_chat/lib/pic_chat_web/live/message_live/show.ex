defmodule PicChatWeb.MessageLive.Show do
  use PicChatWeb, :live_view

  alias PicChat.Chat

  @impl true
  def mount(_params, _session, socket) do
    PicChatWeb.Endpoint.subscribe("chat_messages")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:message, Chat.get_message!(id))}
  end

  defp page_title(:show), do: "Show Message"
  defp page_title(:edit), do: "Edit Message"

  @impl true
  def handle_info(%{event: "delete_message"}, socket) do
    Process.send_after(self(), {"countdown", 2}, 1000)

    {:noreply,
     socket
     |> put_flash(:error, "Oh No! You will be redirected in: 3")}
  end

  def handle_info({"countdown", 1}, socket) do
    {:noreply, put_flash(socket, :error, "Oh No! You will be redirected in: 1 second")}
  end

  def handle_info({"countdown", 0}, socket) do
    {:noreply, push_redirect(socket, to: "/")}
  end

  def handle_info({"countdown", time}, socket) do
    Process.send_after(self(), {"countdown", time - 1}, 1000)
    {:noreply, put_flash(socket, :error, "Oh No! You will be redirected in: #{time} seconds")}
  end
end
