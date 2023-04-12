# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PicChat.Repo.insert!(%PicChat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PicChat.Chat

Enum.each(1..100, fn each ->
  Chat.create_message(%{
    content: "some awesome content #{each}",
    from: "some amazing from #{each}"
  })
end)
