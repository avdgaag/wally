defmodule Mix.Tasks.Wally.ResetUser do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Reset a user's password"

  @moduledoc """
    Reset a user's password in case they lost in, so they can log in again.
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
