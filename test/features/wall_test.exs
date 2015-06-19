defmodule Wally.WallTest do
  use Wally.HoundCase

  test "it shows and updates project information" do
    project = Wally.Repo.insert %Wally.Project{title: "My Project", settings: %{heroku_app: "my-app"}}
    Wally.Repo.insert %Wally.Badge{label: "Deployment", value: "0", project_id: project.id}
    api_token = Wally.Repo.insert %Wally.ApiToken{description: "Heroku"}
    login_with "example@example.com", "secret"
    navigate_to "/"
    :timer.sleep(1000) # sleep so page can render
    assert visible_text(find_element(:class, "project__title")) == "My Project"
    assert visible_text(find_element(:class, "badge")) == "0\nDEPLOYMENT"

    post conn(), "/api/" <> api_token.token <> "/hooks/heroku?app=my-app"

    assert visible_text(find_element(:class, "badge")) == "0 seconds\nDEPLOYMENT"
  end
end
