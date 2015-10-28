defmodule Wally.User do
  @doc """
  Represents a signed in user in the system.
  """

  defstruct email: nil,
    email_verified: nil,
    family_name: nil,
    given_name: nil,
    hd: nil,
    kind: nil,
    locale: "en",
    name: nil,
    picture: nil,
    sub: nil

  def from_google_oauth(map) do
    Enum.reduce map, %Wally.User{}, fn({key, value}, user) ->
      Map.put(user, String.to_atom(key), value)
    end
  end

  def test_user do
    %Wally.User{
      email: "test@example.com",
      email_verified: "true",
      family_name: "Doe",
      given_name: "John",
      hd: "domain.tld",
      kind: "test",
      locale: "en",
      name: "John Doe",
      picture: "http://placekitten.com/g/50/50",
      sub: "123456789"
    }
  end
end
