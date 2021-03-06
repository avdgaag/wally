defmodule Mix.Tasks.Wally.CreateProject do
  use Mix.Task

  @shortdoc "Create a new project"

  @moduledoc """
    A task for setting up a new project in the dashboard, that is able to
    receive incoming webhooks.
  """

  def run([name | _args]) do
    {:ok, project } = Wally.Project.new(name) |> Wally.Repo.persist([:api_token])
    Mix.shell.info """
    Created project #{project.name} with API token #{project.api_token}.

    Use URLs like this to post events:

      http://domain.tld/api/hooks/#{project.api_token}/heroku
      http://domain.tld/api/hooks/#{project.api_token}/errbit
      http://domain.tld/api/hooks/#{project.api_token}/github
    """
  end

  def run([]) do
    Mix.shell.error "No project name provided. Usage: mix wally.create_project my_project"
  end
end
