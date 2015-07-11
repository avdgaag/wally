defmodule Wally.User do
  use Wally.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :api_token, :string

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> hash_password
  end

  defp hash_password(changeset) do
    if changeset.params["password"] do
      changeset
      |> Ecto.Changeset.put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(changeset.params["password"]))
      |> Ecto.Changeset.delete_change(:password)
    else
      changeset
    end
  end

  def find_by_email(email) when is_binary(email) do
    Wally.Repo.get_by(Wally.User, email: email)
  end

  def find_by_email(email) when is_nil(email) do
    nil
  end

  def find_by_id(id) do
    Wally.Repo.get(Wally.User, id)
  end

  def authenticate(email, password) do
    user = find_by_email(email)
    case user do
      %Wally.User{} ->
        case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
          true ->
            {:ok, user}
          _ ->
            {:error, user}
        end
      _ ->
        {:error, user}
    end
  end

  before_insert :set_token
  defp set_token(changeset) do
    changeset |> change(api_token: generate_new_unique_token)
  end

  defp generate_new_unique_token do
    token = Wally.SecureRandom.urlsafe_base64
    query = from r in Wally.User,
            where: r.api_token == ^token,
            limit: 1
    case Wally.Repo.all(query) do
      [] -> token
      [_] -> generate_new_unique_token
    end
  end

  def find_by_token(token) when is_binary(token) do
    Wally.Repo.get_by(Wally.User, api_token: token)
  end

  def find_by_token(token) when is_nil(token) do
    nil
  end
end
