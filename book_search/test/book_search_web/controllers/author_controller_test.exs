defmodule BookSearchWeb.AuthorControllerTest do
  use BookSearchWeb.ConnCase

  import BookSearch.AuthorsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  # Context
  # that's were we build our queries
  # that's where our implementation lives
  # faster

  # Controller
  # higher level -> holistic, comprehensive i.e. catches more bugs
  # tests functionality "less implementation focused"

  # If the controller integrates nicely with the context, then I can rely on more comprehensive contexts tests.

  # Controller -> integrates w/ context
  # Context -> comprehensive tests

  # Application (E2E) -> Router -> Controller (Integration) -> Context (Unit) -> Schema
  # Higher -> Lower

  describe "index" do
    test "Search", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :index))
      assert html_response(conn, 200) =~ "<button type=\"submit\">Search</button>"
    end

    test "lists all authors", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Authors"
    end
  end

  describe "search" do
    test "exact match", %{conn: conn} do
      authorA = author_fixture(name: "Patrick Rothfuss")
      authorB = author_fixture(name: "Dennis E Taylor")
      # send the request
      conn = get(conn, "/authors?name=#{authorA.name}")

      # assert that the correct authors were found
      assert html_response(conn, 200) =~ authorA.name
      refute html_response(conn, 200) =~ authorB.name
    end

    test "partial match beginning", %{conn: conn} do
      authorA = author_fixture(name: "Patrick Rothfuss")
      authorB = author_fixture(name: "Dennis E Taylor")

      conn = get(conn, "/authors?name=Patrick")

      assert html_response(conn, 200) =~ authorA.name
      refute html_response(conn, 200) =~ authorB.name
    end

    test "partial match end", %{conn: conn} do
      authorA = author_fixture(name: "Patrick Rothfuss")
      authorB = author_fixture(name: "Dennis E Taylor")

      conn = get(conn, "/authors?name=Rothfuss")

      assert html_response(conn, 200) =~ authorA.name
      refute html_response(conn, 200) =~ authorB.name
    end

    test "case insensitive match", %{conn: conn} do
      authorA = author_fixture(name: "Patrick Rothfuss")
      authorB = author_fixture(name: "Dennis E Taylor")

      conn = get(conn, "/authors?name=patrick")

      assert html_response(conn, 200) =~ authorA.name
      refute html_response(conn, 200) =~ authorB.name
    end

    test "empty", %{conn: conn} do
      authorA = author_fixture(name: "Patrick Rothfuss")
      authorB = author_fixture(name: "Dennis E Taylor")

      conn = get(conn, "/authors?name=")

      assert html_response(conn, 200) =~ authorA.name
      assert html_response(conn, 200) =~ authorB.name
    end
  end

  describe "new author" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :new))
      assert html_response(conn, 200) =~ "New Author"
    end
  end

  describe "create author" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.author_path(conn, :show, id)

      conn = get(conn, Routes.author_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Author"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Author"
    end
  end

  describe "edit author" do
    setup [:create_author]

    test "renders form for editing chosen author", %{conn: conn, author: author} do
      conn = get(conn, Routes.author_path(conn, :edit, author))
      assert html_response(conn, 200) =~ "Edit Author"
    end
  end

  describe "update author" do
    setup [:create_author]

    test "redirects when data is valid", %{conn: conn, author: author} do
      conn = put(conn, Routes.author_path(conn, :update, author), author: @update_attrs)
      assert redirected_to(conn) == Routes.author_path(conn, :show, author)

      conn = get(conn, Routes.author_path(conn, :show, author))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, author: author} do
      conn = put(conn, Routes.author_path(conn, :update, author), author: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Author"
    end
  end

  describe "delete author" do
    setup [:create_author]

    test "deletes chosen author", %{conn: conn, author: author} do
      conn = delete(conn, Routes.author_path(conn, :delete, author))
      assert redirected_to(conn) == Routes.author_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.author_path(conn, :show, author))
      end
    end
  end

  defp create_author(_) do
    author = author_fixture()
    %{author: author}
  end
end
