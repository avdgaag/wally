defmodule Wally.AuthenticationTest do
  use Wally.HoundCase

  test "requires logging in to access projects" do
    navigate_to "/projects"
    assert page_source =~ ~r{You need to log in first.}
    assert page_source =~ ~r{Log in}
  end

  test "requires logging in to access API tokens" do
    navigate_to "/api_tokens"
    assert page_source =~ ~r{You need to log in first.}
    assert page_source =~ ~r{Log in}
  end

  test "requires logging in to access the wall information" do
    navigate_to "/wall"
    assert page_source =~ ~r{You need to log in first.}
    assert page_source =~ ~r{Log in}
  end

  test "requires logging in to access the homepage" do
    navigate_to "/"
    assert page_source =~ ~r{You need to log in first.}
    assert page_source =~ ~r{Log in}
  end

  test "shows confirmation after logging in" do
    login_with "example@example.com", "secret"
    assert page_source =~ ~r{You have been logged in}
  end
end
