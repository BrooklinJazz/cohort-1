# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BookSearch.Repo.insert!(%BookSearch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BookSearch.Authors
alias BookSearch.Authors.Author
alias BookSearch.Books.Book
alias BookSearch.Repo

{:ok, author} =
  BookSearch.Authors.create_author(%{name: "Patrick Rothfuss", birth_date: ~D[2022-02-02]})

{:ok, book} = BookSearch.Books.create_book(%{title: "Name of the Wind"})

# build_assoc

author
|> Ecto.build_assoc(:books)
|> BookSearch.Books.Book.changeset(%{title: "A Wise Man's Fear"})
|> BookSearch.Repo.insert!()

dennis =
  BookSearch.Authors.Author.changeset(%Author{}, %{
    name: "Dennis E Taylor",
    birth_date: ~D[2022-02-02]
  })
  |> Ecto.Changeset.put_assoc(:books, [%{title: "We are Bob"}])
  |> Repo.insert!()

%Book{}
|> Book.changeset(%{title: "We are Jim"})
|> Ecto.Changeset.put_assoc(:author, dennis)
|> Repo.insert!()
|> IO.inspect()

# create a book -> associate it with an existing author

# cast_assoc

# |> Book.changeset(%{})
