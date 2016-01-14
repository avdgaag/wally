defmodule Mix.Tasks.Wally.ResetToken do
  use Mix.Task

  @shortdoc "Reset a project's API token"

  @moduledoc """
    A task for resetting an existing project's API token. This causes
    the old token to become invalid and no longer work.
  """

  def run([api_token | _args]) do
    with {:ok, project} <- Wally.Repo.get_by(Wally.Project, :api_token, api_token),
         project = %{project | api_token: Wally.SecureToken.generate},
         {:ok, project} <- Wally.Repo.persist(project, [:api_token]),
         do: Mix.shell.info """
      Reset project #{project.name} API token to #{project.api_token}.

      Use URLs like this to post events:

        http://domain.tld/api/hooks/#{project.api_token}/heroku
        http://domain.tld/api/hooks/#{project.api_token}/errbit
        http://domain.tld/api/hooks/#{project.api_token}/github
      """
  end

  def run([]) do
    Mix.shell.error "No project name provided. Usage: mix wally.reset_token API_TOKEN"
  end
end
