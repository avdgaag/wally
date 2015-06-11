defmodule Wally.ProjectsTest do
  use Wally.HoundCase

  test "can create a new project" do
    login_with "example@example.com", "secret"
    navigate_to "/projects"
    click {:link_text, "Add a project"}
    fill_field {:id, "project_title"}, "My new project"
    fill_field {:id, "project_heroku_app"}, "my-new-project"
    click {:class, "btn-primary"}
    assert page_source =~ ~r{Project created successfully}
    assert page_source =~ ~r{My new project}
  end

  test "can edit an existing project" do
    login_with "example@example.com", "secret"
    Wally.Repo.insert %Wally.Project{title: "Example project"}
    navigate_to "/projects"
    assert page_source =~ ~r{Example project}
    click {:link_text, "Edit"}
    fill_field {:id, "project_title"}, "Updated project"
    click {:class, "btn-primary"}
    assert page_source =~ ~r{Project updated successfully}
    assert page_source =~ ~r{Updated project}
  end

  test "can remove an existing project" do
    login_with "example@example.com", "secret"
    Wally.Repo.insert %Wally.Project{title: "Example project"}
    navigate_to "/projects"
    assert page_source =~ ~r{Example project}
    click {:link_text, "Delete"}
    assert page_source =~ ~r{Project deleted successfully}
    refute page_source =~ ~r{Example project}
  end
end
