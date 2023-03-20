defmodule BookSearch.Repo.Migrations.AddBirthDateToAuthorsTable do
  use Ecto.Migration

  # How to find if we broke things
  # Manual Testing
  # Run Tests
  # Let our users test for us
  # psql look at DB
  def change do
    alter table(:authors) do
      add :birth_date, :date, null: false
    end
  end
end
