defmodule Journal.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    IO.inspect("""
    ================================================
    Awesome Migration Incoming!!!!!!!!!!!!!
    ================================================
    """)

    create table(:entries) do
      add :title, :string
      add :content, :text
      add :summary, :text

      timestamps()
    end
  end
end
