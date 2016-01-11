defmodule Wally.Serializer do
  alias Wally.Repo

  @moduledoc """
  Serializes data structures for transport to and usage by the front-end
  application. The serializer will not generate an actual JSON string, but
  it will return maps suitable for JSON serialization.
  """

  @doc """
  Serialize a list of `Wally.Project` structs into a format suitable for
  consumption in the front-end app. This uses `project/1` to transform
  each element in `structs`, _and_ indexes the result by their ID, resulting
  in a map instead of list.
  """
  @spec projects(list(struct)) :: %{binary => map}
  def projects(structs) when is_list(structs) do
    structs
    |> Enum.map(&project/1)
    |> group_by_id
  end

  @doc """
  Serialize a single project. This will use keys in camel-case notation,
  include relevant event IDs from the `Repo` based on the project ID, and
  omit secret or unwanted attributes.
  """
  @spec project(struct) :: map
  def project(struct) when is_map(struct) do
    struct
    |> filter_keys
    |> add_event_ids
    |> camelize_keys
  end

  def events(structs) when is_list(structs) do
    structs
    |> Enum.map(&event/1)
    |> group_by_id
  end

  def event(struct) when is_map(struct) do
    struct
    |> add_project_id
    |> camelize_keys
  end

  defp filter_keys(struct) when is_map(struct) do
    struct
    |> Map.drop([:api_token])
  end

  defp add_event_ids(record) do
    Map.put(record, :event_ids, Repo.child_ids(record, Event))
  end

  defp add_project_id(record) do
    Map.put(record, :project_id, Repo.parent_id(record, Project))
  end

  defp group_by_id(records) do
    for record <- records, into: %{} do
      {record["id"], record}
    end
  end

  defp camelize_keys(record) do
    for {key, value} <- Map.from_struct(record), into: %{} do
      [first | rest] = key
      |> to_string
      |> Phoenix.Naming.camelize
      |> String.graphemes
      camelized_key = [String.downcase(first) | rest] |> Enum.join("")
      {camelized_key, value}
    end
  end
end
