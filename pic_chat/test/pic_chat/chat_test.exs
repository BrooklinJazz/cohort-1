defmodule PicChat.ChatTest do
  use PicChat.DataCase

  alias PicChat.Chat

  describe "messages" do
    alias PicChat.Chat.Message

    import PicChat.ChatFixtures

    @invalid_attrs %{content: nil, from: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chat.list_messages() == [message]
    end

    test "list_messages/1 limit messages" do
      messages =
        Enum.map(1..10, fn each ->
          message_fixture()
        end)

      assert Chat.list_messages(limit: 5) == Enum.slice(messages, 0..4)
    end

    test "list_messages/1 paginate messages" do
      messages =
        Enum.map(1..10, fn each ->
          message_fixture()
        end)

      assert Chat.list_messages(limit: 5, offset: 1) == Enum.slice(messages, 1..5)
    end

    test "list_messages/1 100 messages" do
      messages =
        Enum.map(1..100, fn each ->
          message_fixture()
        end)
        |> Enum.reverse()

      assert Chat.list_messages(limit: 10, offset: 0) == Enum.slice(messages, 0..9)
      assert Chat.list_messages(limit: 10, offset: 10) == Enum.slice(messages, 10..19)
      assert Chat.list_messages(limit: 10, offset: 80) == Enum.slice(messages, 80..89)
      assert Chat.list_messages(limit: 10, offset: 90) == Enum.slice(messages, 90..99)
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: "some content", from: "some from"}

      assert {:ok, %Message{} = message} = Chat.create_message(valid_attrs)
      assert message.content == "some content"
      assert message.from == "some from"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: "some updated content", from: "some updated from"}

      assert {:ok, %Message{} = message} = Chat.update_message(message, update_attrs)
      assert message.content == "some updated content"
      assert message.from == "some updated from"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_message(message, @invalid_attrs)
      assert message == Chat.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end
end
