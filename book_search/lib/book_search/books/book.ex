defmodule BookSearch.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias BookSearch.Authors.Author

  schema "books" do
    field :title, :string
    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author_id])
    |> validate_required([:title])
    |> foreign_key_constraint(:author_id)
  end
end
