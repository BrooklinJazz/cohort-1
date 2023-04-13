defmodule Newsletter.Mailer do
  use Swoosh.Mailer, otp_app: :newsletter
  import Swoosh.Email

  def build_email(name, email) do
    new()
    |> to({name, email})
    |> from({"DockYard", "notifications@dockyard.com"})
    |> subject("Welcome To The DockYard Newsletter")
    |> html_body("<p>Hi #{name}, stay tuned for some great stuff!</p>")
    |> text_body("Seriously, #{name}... Why don't you have HTML turned on? It's 2023.")
  end

  def signup_confirmation(name, email) do
    build_email(name, email)
    |> deliver()
  end
end
