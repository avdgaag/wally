defmodule Mix.Tasks.Wally.CreateUser do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Register a new user"

  @moduledoc """
    A task for registering a new user in the application, so he or she can
    log in and the web app.
  """

  def run([email | _args]) do
    password = Comeonin.Password.gen_password(16)
    ensure_started(Wally.Repo)
    Wally.Repo.insert(Wally.User.changeset(%Wally.User{}, %{"email" => email, "password" => password}), log: false)
    Mix.shell.info "Created user '#{email}' with password:"
    Mix.shell.info password
  end

  def run([]) do
    Mix.shell.error "No email provided. Usage: mix wally.create_user john"
  end
end
