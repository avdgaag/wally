defmodule Wally.ApiTokenTest do
  use Wally.ModelCase

  alias Wally.ApiToken

  @valid_attrs %{description: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ApiToken.changeset(%ApiToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ApiToken.changeset(%ApiToken{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "requires content in description" do
    changeset = ApiToken.changeset(%ApiToken{}, %{description: "", token: "some content"})
    refute changeset.valid?
  end

  test "requires content in token" do
    changeset = ApiToken.changeset(%ApiToken{}, %{description: "some content", token: ""})
    refute changeset.valid?
  end

  test "unique token is generated on creation" do
    Wally.Repo.insert %ApiToken{description: "some content"}
    api_token = Wally.Repo.insert %ApiToken{description: "some content"}
    assert api_token.token
  end
end
