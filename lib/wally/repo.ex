defmodule Wally.Repo do
  alias Exredis.Api

  @moduledoc """
  Map Elixir structs to a Redis database

  The repo is the bridge between Elixir data structures and the Redis key/value
  database. It can be used for persistence. It handles saving, loading,
  counting, testing and associating structs.

  The data model is dictated by the repo. For a struct `Post` with associated
  `Comment` values, the keys are laid out like this:

  * `next_post_id` holds the ID for the next post
  * `post_ids` is a set of all known post IDs.
  * `post:1` is a hash of all attributes for post with ID 1.
  * `post:1:comment_ids` is a set of all IDs for comments associated with
     post with ID 1.
  * `comment_ids` is a set of all known comment IDs.
  * `comment:6` is a hash of all attributes of the comment with ID 6.
  * `comment:6:project` is the ID of the project the comment with ID 6 belongs
    to.
  * `next_comment_id` is the ID for the next comment to be created.

  When persisting new structs, a new ID is generated and assigned. On subsequent
  persist operations, the ID will be unchanged but the persisted record will be
  merged with the new, incoming record.
  """

  @doc "Count the number of records for a given struct module."
  @spec count(module) :: integer
  def count(mod) when is_atom(mod) do
    mod
    |> collection_key
    |> Api.scard
    |> String.to_integer
  end

  @doc "Test if a record with an ID for a given struct module exists."
  @spec exist?(module, binary) :: boolean
  def exist?(mod, id) when is_atom(mod) and is_binary(id) do
    mod
    |> collection_key
    |> Api.sismember(id) == "1"
  end

  @doc "Test if a struct exists as a record in the database."
  @spec exist?(map) :: boolean
  def exist?(%{__struct__: mod, id: id}) when is_atom(mod) and is_binary(id) do
    exist?(mod, id)
  end

  @doc "Load all known records for a given struct module."
  @spec all(map) :: {:ok, [map]}
  def all(mod) when is_atom(mod) do
    ids = mod
    |> collection_key
    |> Api.smembers
    get(mod, ids)
  end

  @doc "Load one or more records by ID for a given struct module."
  @spec get(module, binary|list) :: map
  def get(mod, id) when is_atom(mod) and is_binary(id) do
    if exist?(mod, id) do
      if has_attributes?(mod, id) do
        {:ok, do_get(mod, id)}
      else
        {:error, "Missing attributes for ID"}
      end
    else
      {:error, "No such ID"}
    end
  end

  def get(mod, ids) when is_atom(mod) and is_list(ids) do
    results = Enum.map(ids, &(get(mod, &1)))
    if Keyword.has_key?(results, :error) do
      {:error, Keyword.get(results, :error)}
    else
      {:ok, Keyword.values(results)}
    end
  end

  @doc "Load one or more records by a specific attribute value."
  @spec get_by(module, atom, binary) :: {:ok, [map]}
  def get_by(mod, key, values) when is_atom(mod) and is_atom(key) and is_list(values) do
    get(mod, Api.hmget(index_key(mod, key), values))
  end

  def get_by(mod, key, value) when is_atom(mod) and is_atom(key) and not is_nil(value) do
    case Api.hget(index_key(mod, key), value) do
      :undefined -> {:error, "No such " <> to_string(key)}
      id -> get(mod, id)
    end
  end

  @doc "Destroy a persisted record."
  @spec destroy(map) :: :ok
  @spec destroy(map) :: {:error, binary}
  def destroy(%{__struct__: mod, id: id} = struct) when not is_nil(id) do
    if exist?(struct) do
      1 = Api.del(record_key(struct))
      "1" = Api.srem(collection_key(mod), id)
      :ok
    else
      {:error, "No such ID"}
    end
  end

  @doc "Persist a new or changed record to the database"
  @spec persist(map) :: {:ok, map}
  def persist(%{__struct__: mod, id: id} = struct) when is_atom(mod) and not is_nil(id) do
    do_persist(struct, [])
  end

  def persist(%{__struct__: mod} = struct) when is_atom(mod) do
    persist(struct, [])
  end

  def persist(%{__struct__: mod, id: id} = struct, index_by) when is_atom(mod) and not is_nil(id) and is_list(index_by) do
    do_persist(struct, index_by)
  end

  def persist(%{__struct__: mod} = struct, index_by) when is_atom(mod) and is_list(index_by) do
    Api.watch(sequence_key(mod))
    struct_with_id = Map.put(struct, :id, next_id(sequence_key(mod)))
    expected_results = Enum.reduce(index_by, [struct_with_id.id, "1", "OK"], fn _key, acc -> List.insert_at(acc, -2, "OK") end)
    transaction(fn ->
      persist_and_increment_sequence(struct_with_id, index_by)
    end, expected_results)
  end

  defp persist_and_increment_sequence(%{__struct__: mod, id: id} = struct, index_by) do
    # Don't use Exredis.Api here, because it wants to parse the response of INC
    # as an integer -- but in a transaction the result is always "QUEUED".
    Exredis.query(Exredis.Api.defaultclient, ["INCR", sequence_key(mod)])
    Api.sadd(collection_key(mod), id)
    do_persist(struct, index_by)
  end

  defp next_id(key) do
    case Api.get(key) do
      # When the key has not been set before, we'll get :undefined back.
      # Manually use a default value of 1.
      :undefined -> "1"

      # Using get will give us a string which we have to manually increment
      # because we cannot use INCR -- in a transaction it will return QUEUED
      # instead of the incremented value.
      i -> Integer.to_string(String.to_integer(i) + 1)
    end
  end

  defp transaction(fun, expected_results, attempt \\ 1) do
    Api.multi
    result = fun.()
    case Api.exec do
      ^expected_results -> result
      other ->
        if attempt <= 5 do
          IO.puts "Retrying failed transaction because of queue expectation mismatch (#{attempt}/5):"
          IO.inspect(expected_results)
          IO.inspect(other)
          transaction(fun, expected_results, attempt + 1)
        else
          IO.puts "Aborting failed transaction after 5 attempts. Expected results did not match actual results."
          {:error, "Transaction failed"}
        end
    end
  end

  defp sequence_key(mod) do
    "next_" <> resource_name(mod) <> "_id"
  end

  @doc "Associate two records in a has-many relationship"
  @spec associate(map, map) :: :ok
  def associate(%{id: parent_id} = parent, %{id: child_id} = child) do
    "1" = Api.sadd(has_many_key(parent, child), child_id)
    :ok = Api.set(belongs_to_key(parent, child), parent_id)
    :ok
  end

  @doc "Get all IDs for child records for a given parent record in a has-many relationship"
  @spec child_ids(map, module) :: {:ok, [integer]}
  @spec child_ids(map, module) :: {:error, binary}
  def child_ids(parent, child_mod) do
    parent
    |> has_many_key(child_mod)
    |> Api.smembers
  end

  @doc "Get all child records for a parent record in a has-many relationship"
  @spec children(map, module) :: {:ok, [map]}
  @spec children(map, module) :: {:error, binary}
  def children(parent, child_mod) do
    get(child_mod, child_ids(parent, child_mod))
  end

  @doc "Get the ID for the parent record for a child record in a belongs-to relationship"
  @spec parent_id(map, module) :: {:ok, integer}
  @spec parent_id(map, module) :: {:error, binary}
  def parent_id(child, parent_mod) do
    parent_mod
    |> belongs_to_key(child)
    |> Api.get
  end

  @doc "Get the parent record for a child record in a belongs-to relationship"
  @spec parent(map, module) :: {:ok, map}
  @spec parent(map, module) :: {:error, binary}
  def parent(child, parent_mod) do
    get(parent_mod, parent_id(child, parent_mod))
  end

  defp has_many_key(parent, child) do
    record_key(parent) <> ":" <> collection_key(child)
  end

  defp belongs_to_key(parent, child) do
    record_key(child) <> ":" <> resource_name(parent)
  end

  defp do_persist(%{id: id} = struct, index_by) when not is_nil(id) and is_list(index_by) do
    attributes =
      for {key, value} <- Map.from_struct(struct),
        !is_nil(value),
        into: [],
        do: [key, value]
    Api.hmset(record_key(struct), List.flatten(attributes))
    Enum.each(index_by, fn (key) ->
      Api.hmset(index_key(struct, key), [Map.get(struct, key), id])
    end)
    {:ok, struct}
  end

  defp do_get(mod, id) do
    mod
    |> record_key(id)
    |> Api.hgetall
    |> Enum.reduce(mod.__struct__, fn ({key, value}, struct) ->
      Map.put(struct, String.to_atom(key), value)
    end)
  end

  defp has_attributes?(mod, id) do
    Api.exists(record_key(mod, id)) == 1
  end

  defp index_key(%{__struct__: mod}, key) do
    index_key(mod, key)
  end

  defp index_key(mod, key) when is_atom(mod) and is_atom(key) do
    resource_name(mod) <> ":by_" <> to_string(key)
  end

  defp record_key(%{__struct__: mod, id: id}) do
    record_key(mod, id)
  end

  defp record_key(mod, id) when is_binary(id) do
    resource_name(mod) <> ":" <> id
  end

  defp collection_key(%{__struct__: mod}) do
    collection_key(mod)
  end

  defp collection_key(mod) when is_atom(mod) do
    resource_name(mod) <> "_ids"
  end

  defp resource_name(%{__struct__: mod}) do
    resource_name(mod)
  end

  defp resource_name(mod) when is_atom(mod) do
    mod
    |> Atom.to_string
    |> Phoenix.Naming.resource_name
  end
end
