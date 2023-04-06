defmodule PicChat.Repo.Migrations.AddMediaToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :media, :string
    end
  end
end
