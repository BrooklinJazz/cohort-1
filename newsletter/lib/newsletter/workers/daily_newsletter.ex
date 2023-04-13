defmodule Newsletter.Workers.DailyNewsletter do
  use Oban.Worker, queue: :default, max_attempts: 10

  @day 60 * 60 * 24
  @impl true
  # perform is called
  # Email fails

  def perform(%{args: user}) do
    case Newsletter.Mailer.signup_confirmation(user["name"], user["email"]) do
      :ok ->
        new(user, schedule_in: @day)
        |> Oban.insert!()

      _ ->
        :error
    end
  end
end
