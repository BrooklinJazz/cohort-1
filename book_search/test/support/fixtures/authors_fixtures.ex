defmodule BookSearch.AuthorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookSearch.Authors` context.
  """

  @doc """
  Generate a author.
  """
  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> Enum.into(%{
        name: "some name",
        birth_date: Date.new!(2000, 6, 28)
      })
      |> BookSearch.Authors.create_author()

    author
  end
end
