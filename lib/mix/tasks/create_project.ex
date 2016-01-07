defmodule Mix.Tasks.Wally.CreateProject do
  use Mix.Task

  @shortdoc "Create a new project"

  @moduledoc """
    A task for setting up a new project in the dashboard, that is able to
    receive incoming webhooks.
  """

  def run([name | _args]) do
    token = :crypto.strong_rand_bytes(32)
    |> Base.url_encode64
    |> binary_part(0, 32)
    project = %Wally.Project{
      name: name,
      api_token: token
    }
    Wally.Repo.persist(project, [:api_token])
    Mix.shell.info """
    Created project #{name} with API token #{token}.

    Use URLs like this to post events:

      http://domain.tld/api/hooks/#{token}/heroku
      http://domain.tld/api/hooks/#{token}/errbit
      http://domain.tld/api/hooks/#{token}/github
    """
  end

  def run([]) do
    Mix.shell.error "No project name provided. Usage: mix wally.create_project my_project"
  end
end
