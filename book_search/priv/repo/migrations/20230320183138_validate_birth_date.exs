defmodule BookSearch.Repo.Migrations.ValidateBirthDate do
  use Ecto.Migration

  def change do
    create constraint(:authors, :birth_date, check: "birth_date <= CURRENT_DATE")
  end
end
