defmodule Mix.Tasks.Wally.ResetUser do
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
    user = Wally.User.find_by_email(email)
    Wally.Repo.update(Wally.User.changeset(user, %{"password" => password}), log: false)
    Mix.shell.info "Reset password for user '#{email}' to:"
    Mix.shell.info password
  end

  def run([]) do
    Mix.shell.error "No email provided. Usage: mix wally.create_user john"
  end
end
