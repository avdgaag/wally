defmodule Wally.ApiTokensTest do
  use ExUnit.Case
  use Hound.Helpers

  hound_session

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Wally.Repo, [])
    end
  end

  test "can create a new token" do
    navigate_to "/api_tokens"
    click({:link_text, "Add an API token"})
    fill_field({:id, "api_token_description"}, "Example token")
    click({:class, "btn-primary"})
    assert page_source =~ ~r{ApiToken created successfully.}
    assert page_source =~ ~r{Example token}
  end

  test "can revoke a token" do
    Wally.Repo.insert %Wally.ApiToken{description: "To be revoked"}
    navigate_to "/api_tokens"
    assert length(find_all_elements(:class, "api-token")) == 1
    click({:link_text, "Delete"})
    assert page_source =~ ~r{ApiToken deleted successfully.}
    assert length(find_all_elements(:class, "api-token")) == 0
  end
end
