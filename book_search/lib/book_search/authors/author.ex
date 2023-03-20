defmodule BookSearch.Authors.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :name, :string
    field :birth_date, :date

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :birth_date])
    |> validate_required([:name, :birth_date])
    |> validate_change(:birth_date, fn :birth_date, birth_date ->
      case Date.compare(Date.utc_today(), birth_date) do
        :lt ->
          [birth_date: "can't be in the future"]

        _ ->
          []
      end
    end)
  end
end
