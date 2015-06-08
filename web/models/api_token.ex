defmodule Wally.ApiToken do
  use Wally.Web, :model

  schema "api_tokens" do
    field :description, :string
    field :token, :string

    timestamps
  end

  @required_fields ~w(description)
  @optional_fields ~w(token)

  before_insert :set_token

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:description, min: 1)
    |> validate_length(:token, min: 1)
  end

  defp set_token(changeset) do
    token = generate_new_unique_token
    changeset |> change(token: token)
  end

  defp generate_new_unique_token do
    token = Wally.SecureRandom.urlsafe_base64
    query = from r in Wally.ApiToken,
            where: r.token == ^token,
            limit: 1
    case Wally.Repo.all(query) do
      [] -> token
      [_] -> generate_new_unique_token
    end
  end

  def find_by_token(token) when is_binary(token) do
    Wally.Repo.get_by(Wally.ApiToken, token: token)
  end

  def find_by_token(token) when is_nil(token) do
    nil
  end
end
