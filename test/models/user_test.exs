defmodule Wally.UserTest do
  use Wally.ModelCase

  alias Wally.User

  @valid_attrs %{"email" => "some content", "password" => "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "automatically hashes password" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Map.get(changeset.changes, :password) == nil
    refute changeset.changes.password_hash == nil
    refute changeset.changes.password_hash == Map.get(@valid_attrs, "password")
  end

  test "is invalid without a password" do
    changeset = User.changeset(%User{}, %{"email" => "bla"})
    refute changeset.valid?
  end

  test "finds records by ID in the database" do
    user = Repo.insert(User.changeset(%User{}, @valid_attrs))
    assert user == User.find_by_id(user.id)
  end

  test "finds records by email in the database" do
    user = Repo.insert(User.changeset(%User{}, @valid_attrs))
    assert user == User.find_by_email(user.email)
  end

  test "returns authenticated user for email and password" do
    actual_user = Repo.insert(User.changeset(%User{}, @valid_attrs))
    {:ok, expected_user} = User.authenticate("some content", "some content")
    assert actual_user == expected_user
  end

  test "returns error tuple when authentication fails for password " do
    actual_user = Repo.insert(User.changeset(%User{}, @valid_attrs))
    {:error, expected_user} = User.authenticate("some content", "incorrect")
    assert actual_user == expected_user
  end

  test "returns error tuple when authentication fails for incorrect email " do
    {:error, expected_user} = User.authenticate("incorrect", "some content")
    assert expected_user == nil
  end
end
