defmodule Wally.HoundCase do
  @moduledoc """
  This module defines the test case to be used by
  Hound acceptance tests.

  This includes the relevant Hound helpers to control
  a web driver such as PhantomJS, relevant custom helpers
  and ensures tests run in a database transaction.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      # The default endpoint for testing
      @endpoint Wally.Endpoint

      use Hound.Helpers
      hound_session

      defp login_with(username, password) do
        Wally.Repo.insert(Wally.User.changeset(%Wally.User{}, %{"email" => username, "password" => password}))
        navigate_to "/login"
        fill_field({:id, "user_email"}, username)
        fill_field({:id, "user_password"}, password)
        click({:class, "btn-primary"})
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Wally.Repo, [])
    end
  end
end
