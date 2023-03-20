defmodule BookSearch.AuthorsTest do
  use BookSearch.DataCase

  alias BookSearch.Authors

  describe "authors" do
    alias BookSearch.Authors.Author

    import BookSearch.AuthorsFixtures

    @invalid_attrs %{name: nil}

    test "list_authors/0 with two authors returns all authors" do
      author1 = author_fixture()
      {:ok, author2} = Authors.create_author(%{name: "Mohsin :)", birth_date: ~D[2022-01-20]})

      assert Authors.list_authors() == [author1, author2]
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Authors.list_authors() == [author]
    end

    test "list_authors/1 exact match" do
      authorA = author_fixture(name: "A")
      authorB = author_fixture(name: "B")
      assert Authors.list_authors(name: authorA.name) == [authorA]
    end

    test "list_authors/1 partial match" do
      author = author_fixture(name: "Patrick Rothfuss")

      assert Authors.list_authors(name: "Patrick") == [author]
      assert Authors.list_authors(name: "Rothfuss") == [author]
    end

    test "list_authors/1 case insensitive" do
      author = author_fixture(name: "Patrick Rothfuss")

      assert Authors.list_authors(name: "patrick") == [author]
      assert Authors.list_authors(name: "rothfuss") == [author]
    end

    test "list_authors/1 empty" do
      authorA = author_fixture()
      authorB = author_fixture()

      assert Authors.list_authors(name: "") == [authorA, authorB]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Authors.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      valid_attrs = %{name: "some name", birth_date: ~D[2000-06-28]}

      assert {:ok, %Author{} = author} = Authors.create_author(valid_attrs)
      assert author.name == "some name"
    end

    test "create_author/1 with todays date creates an author" do
      today = Date.utc_today()
      valid_attrs = %{name: "some name", birth_date: today}
      assert {:ok, %Author{} = author} = Authors.create_author(valid_attrs)
    end

    test "create_author/1 with date in the future returns error changeset" do
      future = Date.add(Date.utc_today(), 1)
      valid_attrs = %{name: "some name", birth_date: future}
      assert {:error, %Ecto.Changeset{}} = Authors.create_author(valid_attrs)
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Author{} = author} = Authors.update_author(author, update_attrs)
      assert author.name == "some updated name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_author(author, @invalid_attrs)
      assert author == Authors.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Authors.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Authors.change_author(author)
    end
  end
end
