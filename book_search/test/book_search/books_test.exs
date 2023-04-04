defmodule BookSearch.BooksTest do
  use BookSearch.DataCase

  alias BookSearch.Books

  describe "books" do
    alias BookSearch.Books.Book

    import BookSearch.BooksFixtures
    import BookSearch.AuthorsFixtures

    @invalid_attrs %{title: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert [book1] = Books.list_books()
      assert book.id == book1.id
      assert book.title == book1.title
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      retrieved = Books.get_book!(book.id)
      assert retrieved.id == book.id
      assert retrieved.title == book.title
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
    end

    test "create_book/1 with author associates the book and author" do
      author = author_fixture()
      valid_attrs = %{title: "some title", author_id: author.id}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.author_id == author.id
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture() |> Map.delete(:author)

      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)

      assert book == Books.get_book!(book.id) |> Map.delete(:author)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end
end
